import UIKit

// MARK: - Protocol
protocol CartPresenterProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    func showFilters()
    func showPayment()
    func getOrder()
}

// MARK: - Enums
enum CartState {
    case initial, loading, failed(Error), data
}

enum CartFilterChoice: String {
    case price, name, rating, none
}

// MARK: - Presenter
final class CartPresenter: NSObject {

    // MARK: - Properties
    private weak var view: CartViewProtocol?
    var router: CartRouterProtocol
    var interactor: CartInteractorProtocol

    private var orderItems: Order?
    private var nftsInCart: [Nft] = []
    private var state: CartState = .initial {
        didSet { stateDidChanged() }
    }

    // MARK: - Init
    init(interactor: CartInteractorProtocol, router: CartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func attachView(_ view: CartViewProtocol) {
        self.view = view
        getOrder()
    }

    // MARK: - State Management
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoader()
        case .failed(let error):
            print(error)
            view?.hideLoader()
            // TODO: show alert
        case .data:
            view?.hideLoader()
            let choice = loadLastFilterChoice()
            filterNftBy(filterChoice: choice)
            if nftsInCart.isEmpty {
                view?.showPlaceholder()
            } else {
                showNfts()
            }
        }
    }

    // MARK: - Fetching Data
    private func getNfts() {
        guard let orderItems else { return }
        let dispatchGroup = DispatchGroup()
        nftsInCart = []

        for id in orderItems.nfts {
            dispatchGroup.enter()
            interactor.getNFTByID(id: id) { [weak self] result in
                defer { dispatchGroup.leave() }
                guard let self else { return }

                switch result {
                case .success(let nft):
                    self.nftsInCart.append(nft)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.state = .data
        }
    }

    // MARK: - UI Updates
    private func showNfts() {
        let totalPrice = nftsInCart.reduce(0) { $0 + $1.price }
        let numberOfItems = nftsInCart.count

        view?.showNfts(
            totalPrice: totalPrice.toString(),
            numberOfItems: numberOfItems.toString()
        )
    }

    // MARK: - Filtering
    private func filterNftBy(filterChoice: CartFilterChoice) {
        saveFilterChoice(filterChoice)

        switch filterChoice {
        case .price:
            NftFilters.filterByPrice(nft: &nftsInCart)
        case .name:
            NftFilters.filterByName(nft: &nftsInCart)
        case .rating:
            NftFilters.filterByRating(nft: &nftsInCart)
        case .none:
            break
        }

        view?.reloadTable()
    }

    // MARK: - Saving/Loading Filters
    private func saveFilterChoice(_ choice: CartFilterChoice) {
        UserDefaults.standard.set(choice.rawValue, forKey: "CartFilter")
    }

    private func loadLastFilterChoice() -> CartFilterChoice {
        guard let rawValue = UserDefaults.standard.string(forKey: "CartFilter"),
              let choice = CartFilterChoice(rawValue: rawValue) else {
            return .none
        }
        return choice
    }
}

// MARK: - CartPresenterProtocol
extension CartPresenter: CartPresenterProtocol {
    func showFilters() {
        let buttons = [
            FilterMenuButtonModel(title: Localization.filterChoicePrice) { [weak self] in
                self?.filterNftBy(filterChoice: .price)
            },
            FilterMenuButtonModel(title: Localization.filterChoiceRating) { [weak self] in
                self?.filterNftBy(filterChoice: .rating)
            },
            FilterMenuButtonModel(title: Localization.filterChoiceName) { [weak self] in
                self?.filterNftBy(filterChoice: .name)
            }
        ]
        let filterVC = FilterViewController(buttons: buttons)
        router.showCartFilters(filterVC: filterVC)
    }

    func showPayment() {
        router.showPaymentPage { [weak self] in
            guard let self else { return }
            self.state = .loading
            self.interactor.updateOrder(nfts: []) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    self.getOrder()
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    func getOrder() {
        state = .loading
        interactor.getNFTInsideCart { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                self.orderItems = order
                self.getNfts()
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension CartPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - UITableViewDataSource
extension CartPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell
        guard let cell else { return UITableViewCell() }

        let nft = nftsInCart[indexPath.row]
        cell.configure(
            imageURL: nft.images[0],
            name: nft.name,
            rating: nft.rating,
            price: nft.price) { [weak self] in
                guard let self else { return }
                self.router.showDeletePage(imageUrlString: nft.images[0]) { [weak self] in
                    guard let self else { return }
                    self.deleteNftFromCartAction(indexPath: indexPath)
                }
            }
        return cell
    }

    private func deleteNftFromCartAction(indexPath: IndexPath) {
        nftsInCart.remove(at: indexPath.row)

        let nftsIds = nftsInCart.map { $0.id }
        interactor.updateOrder(nfts: nftsIds) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.getOrder()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

import Foundation

protocol UserCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    var cart: Cart? { get }
    var profile: Profile? { get }
    func updateCart(nfts: [String])
    func updateProfile(likes: [String])
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    weak var view: UserCollectionViewProtocol?
    private let interactor: UserCollectionInteractorProtocol
    private let router: UserCollectionRouterProtocol
    private let userId: String
    private(set) var profile: Profile?
    private(set) var cart: Cart?
    private var nfts: [NFT]?

    init(
        view: UserCollectionViewProtocol,
        interactor: UserCollectionInteractorProtocol,
        router: UserCollectionRouterProtocol,
        userId: String
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.userId = userId
    }

    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.fetchNFTs(for: userId)
        interactor.fetchCart(for: userId)
        interactor.fetchProfile(for: userId)
    }

    func updateCart(nfts: [String]) {
        interactor.updateCart(nfts: nfts)
    }

    func updateProfile(likes: [String]) {
        interactor.updateProfile(likes: likes)
    }
}

extension UserCollectionPresenter: UserCollectionInteractorOutputProtocol {
    func didFetchNFTs(_ nfts: [NFT]) {
        view?.hideLoadingIndicator()
        view?.showNFTs(nfts)
    }

    func didFetchCart(_ cart: Cart) {
        self.cart = cart
    }

    func didUpdateCart(_ cart: Cart) {
        self.cart = cart
        if let nfts = self.nfts {
            view?.showNFTs(nfts)
        }
    }

    func didFetchProfile(_ profile: Profile) {
        self.profile = profile
    }

    func didUpdateProfile(_ profile: Profile) {
        self.profile = profile
        if let nfts = self.nfts {
            view?.showNFTs(nfts)
        }
    }

    func handleError(with error: Error) {
        view?.hideLoadingIndicator()
        view?.showError(error)
    }
}

import UIKit

protocol StatisticPresenterProtocol: AnyObject, UITableViewDelegate, UITableViewDataSource {
    func viewDidLoad()
    func sortUsers(by option: SortOption)
}

class StatisticPresenter: NSObject {

    weak var view: StatisticViewProtocol?
    var router: StatisticRouterProtocol
    var interactor: StatisticInteractorProtocol

    private var users: [UserStatistic] = []

    init(interactor: StatisticInteractorProtocol, router: StatisticRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.showLoadingIndicator()
        interactor.fetchUsers()
    }

    func sortUsers(by option: SortOption) {

        interactor.sortUsers(by: option)
    }
}

extension StatisticPresenter: StatisticInteractorOutputProtocol {
    func didFetchUsers(_ users: [UserStatistic]) {
        self.users = users
        view?.hideLoadingIndicator()
        view?.reloadData()
    }

    func didFailFetchingUsers(with error: Error) {
        view?.hideLoadingIndicator()
        print("Ошибка загрузки данных: \(error)")
    }
}

extension StatisticPresenter: StatisticPresenterProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "StatisticCell",
            for: indexPath
        ) as? StatisticCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        let firstName = user.name.components(separatedBy: " ").first ?? ""

        cell.configure(
            rank: indexPath.row + 1,
            name: firstName,
            avatarURL: user.avatar,
            nftCount: user.nftCount
        )
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        router.showUserDetail(userId: selectedUser.id)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 2 {
            interactor.fetchUsers()
        }
    }
}

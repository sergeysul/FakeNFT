import Foundation

protocol StatisticInteractorProtocol: AnyObject {
    var presenter: StatisticInteractorOutputProtocol? { get set }
    func fetchUsers()
    func sortUsers(by option: SortOption)
}

protocol StatisticInteractorOutputProtocol: AnyObject {
    func didFetchUsers(_ users: [UserStatistic])
    func didFailFetchingUsers(with error: Error)

}

final class StatisticInteractor: StatisticInteractorProtocol {
    weak var presenter: StatisticInteractorOutputProtocol?
    private let networkClient: NetworkClient
    private var users: [UserStatistic] = []
    private var currentPage = 0
    private let pageSize = 10
    private var isLoading = false
    private var hasMoreUsers = true
    private var currentSortOption: SortOption = .byRank

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient

        if let savedSort = UserDefaults.standard.string(forKey: SortOption.key),
           let savedSortOption = SortOption(rawValue: savedSort) {
            self.currentSortOption = savedSortOption
        }
    }

    func fetchUsers() {
        guard !isLoading, hasMoreUsers else { return }
        isLoading = true
        let request = StatisticRequest(page: currentPage, size: pageSize)

        networkClient.send(request: request, type: [UserStatistic].self) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let newUsers):
                if newUsers.isEmpty {
                    self.hasMoreUsers = false
                } else {
                    self.users.append(contentsOf: newUsers)
                    self.currentPage += 1
                }
                self.applySorting()
                self.presenter?.didFetchUsers(self.users)
            case .failure(let error):
                self.presenter?.didFailFetchingUsers(with: error)
            }
        }
    }

    func sortUsers(by option: SortOption) {
        currentSortOption = option
        UserDefaults.standard.setValue(option.rawValue, forKey: SortOption.key)
        applySorting()
        presenter?.didFetchUsers(users)
    }

    private func applySorting() {
        switch currentSortOption {
        case .byName:
            users.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byRank:
            users.sort { $0.nftCount > $1.nftCount }
        }
    }
}

import Foundation

protocol UserDetailInteractorProtocol: AnyObject {
    var presenter: UserDetailInteractorOutputProtocol? { get set }
    func fetchUserDetail(userId: String)
}

protocol UserDetailInteractorOutputProtocol: AnyObject {
    func didFetchUserDetail(_ user: UserDetail)
    func didFailFetchingUserDetail(with error: Error)
}

final class UserDetailInteractor: UserDetailInteractorProtocol {
    weak var presenter: UserDetailInteractorOutputProtocol?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchUserDetail(userId: String) {
        let request = UserDetailRequest(userId: userId)

        networkClient.send(request: request, type: UserDetail.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.presenter?.didFetchUserDetail(user)
            case .failure(let error):
                self.presenter?.didFailFetchingUserDetail(with: error)
            }
        }
    }
}

import Foundation

protocol UserCollectionInteractorProtocol: AnyObject {
    var presenter: UserCollectionInteractorOutputProtocol? { get set }
    func fetchNFTs(for userId: String)
    func fetchCart(for userId: String)
    func updateCart(nfts: [String])
    func fetchProfile(for userId: String)
    func updateProfile(likes: [String])
}

protocol UserCollectionInteractorOutputProtocol: AnyObject {
    func didFetchNFTs(_ nfts: [NFT])
    func didFetchCart(_ cart: Cart)
    func didUpdateCart(_ cart: Cart)
    func didFetchProfile(_ profile: Profile)
    func didUpdateProfile(_ profile: Profile)
    func handleError(with error: Error)
}

final class UserCollectionInteractor: UserCollectionInteractorProtocol {
    weak var presenter: UserCollectionInteractorOutputProtocol?
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchNFTs(for userId: String) {
        let request = UserDetailRequest(userId: userId)

        networkClient.send(request: request, type: UserDetail.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.fetchNFTs(for: user.nfts)
            case .failure(let error):
                self.presenter?.handleError(with: error)
            }
        }
    }

    func fetchCart(for userId: String) {
        let request = CartRequest()

        networkClient.send(request: request, type: Cart.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let cart):
                self.presenter?.didFetchCart(cart)
            case .failure(let error):
                self.presenter?.handleError(with: error)
            }
        }
    }

    func updateCart(nfts: [String]) {
        let request = CartUpdateRequest(nfts: nfts)

        networkClient.send(request: request, type: Cart.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let cart):
                self.presenter?.didUpdateCart(cart)
            case .failure(let error):
                self.presenter?.handleError(with: error)
            }
        }
    }

    func fetchProfile(for userId: String) {

        let request = ProfileRequest()

        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.presenter?.didFetchProfile(profile)
            case .failure(let error):
                self.presenter?.handleError(with: error)
            }
        }
    }

    func updateProfile(likes: [String]) {

        let request = ProfileUpdateRequest(likes: likes)

        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.presenter?.didUpdateProfile(profile)
            case .failure(let error):
                self.presenter?.handleError(with: error)
            }
        }
    }

    private func fetchNFTs(for nftIds: [String]) {
        var nfts: [NFT] = []
        let group = DispatchGroup()

        for nftId in nftIds {
            group.enter()
            let request = UserCollectionRequest(nftId: nftId)
            networkClient.send(request: request, type: NFT.self) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    print("Interactor: Ошибка загрузки NFT \(nftId): \(error.localizedDescription)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.presenter?.didFetchNFTs(nfts)
        }
    }
}

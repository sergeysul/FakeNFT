final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var nftCollectionListInteractor: NFTCollectionListInteractorProtocol {
        NFTCollectionListInteractor(
            networkClient: networkClient,
            nftStorage: nftStorage
        )
    }

    var nftCollectionDetailInteractor: NFTCollectionDetailInteractorProtocol {
        NFTCollectionDetailInteractor(
            networkClient: networkClient,
            nftStorage: nftStorage
        )
    }

    var nftDetailInteractor: NFTDetailInteractorProtocol {
        NFTDetailInteractor(
            networkClient: networkClient,
            nftStorage: nftStorage
        )
    }
}

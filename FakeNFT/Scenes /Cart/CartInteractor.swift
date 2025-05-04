protocol CartInteractorProtocol: AnyObject {
    func getNFTInsideCart(completion: @escaping OrderCompletion)
    func getNFTByID(id: String, completion: @escaping NftCompletion)
    func updateOrder(nfts: [String], completion: @escaping UpdateOrderCompletion)
}

final class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?
    private let servicesAssembly: ServicesAssembly

    init(
        serviceAssembly: ServicesAssembly
    ) {
        self.servicesAssembly = serviceAssembly
    }

    func getNFTInsideCart(completion: @escaping OrderCompletion) {
        servicesAssembly.nftService.loadCart(completion: completion)
    }

    func getNFTByID(
        id: String,
        completion: @escaping NftCompletion
    ) {
        servicesAssembly.nftService.getNFTById(
            id: id,
            completion: completion
        )
    }

    func updateOrder(
        nfts: [String],
        completion: @escaping UpdateOrderCompletion
    ) {
        servicesAssembly.nftService.sendUpdateOrderRequest(
            nfts: nfts,
            completion: completion)
    }
}

import Foundation

typealias UpdateOrderCompletion = (Result<UpdateOrderResponse, Error>) -> Void
typealias CartCompletion = (Result<Order, Error>) -> Void
typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias CurrencyCompletion = (Result<[Currency], Error>) -> Void
typealias PayForOrderCompletion = (Result<PayForOrderResponse, Error>) -> Void

protocol NftService {
    func loadCart(completion: @escaping OrderCompletion)
    func sendUpdateOrderRequest(nfts: [String], completion: @escaping UpdateOrderCompletion)
    func getNFTById(id: String, completion: @escaping NftCompletion)
    func getCurrency(completion: @escaping CurrencyCompletion)
    func setCurrencyIdAndPay(id: String, completion: @escaping PayForOrderCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadCart(completion: @escaping OrderCompletion) {
        let request = NetworkRequests.getNFTInsideCart()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNFTById(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NetworkRequests.getNFTById(id: id)
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func sendUpdateOrderRequest(
        nfts: [String],
        completion: @escaping UpdateOrderCompletion
    ) {
        let dto = UpdateOrderDto(nfts: nfts)
        let request = NetworkRequests.putOrder1(dto: dto)
        networkClient.send(request: request, type: UpdateOrderResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCurrency(completion: @escaping CurrencyCompletion) {
        let request = NetworkRequests.getCurrencies()
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setCurrencyIdAndPay(
        id: String,
        completion: @escaping PayForOrderCompletion
    ) {
        let request = NetworkRequests.setCurrencyIdAndPay(id: id)
        networkClient.send(request: request, type: PayForOrderResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

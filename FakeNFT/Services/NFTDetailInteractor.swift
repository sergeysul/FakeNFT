//
//  NFTDetailInteractor.swift
//  Super easy dev
//
//  Created by Nikolay on 20.02.2025
//

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void

protocol NFTDetailInteractorProtocol: AnyObject {
}

final class NFTDetailInteractor: NFTDetailInteractorProtocol {

    // MARK: - Public Properties
    weak var presenter: NFTDetailPresenterProtocol?

    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    // MARK: - Initializers
    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    func loadCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

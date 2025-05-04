//
//  NFTCollectionListInteractor.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//

typealias NftCollectionListCompletion = (Result<[NftCollection], Error>) -> Void

protocol NFTCollectionListInteractorProtocol: AnyObject {
    func loadNftCollectionList(page: Int, size: Int, completion: @escaping NftCollectionListCompletion)
}

final class NFTCollectionListInteractor: NFTCollectionListInteractorProtocol {

    // MARK: - Public Properties
    weak var presenter: NFTCollectionListPresenterProtocol?

    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    func loadNftCollectionList(page: Int, size: Int, completion: @escaping NftCollectionListCompletion) {
        let request = NFTCollectionListRequest(page: page, size: size)
        networkClient.send(request: request, type: [NftCollection].self) { result in
            switch result {
            case .success(let nftCollectionList):
                completion(.success(nftCollectionList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

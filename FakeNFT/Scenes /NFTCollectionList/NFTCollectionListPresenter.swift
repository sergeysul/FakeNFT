//
//  NFTCollectionListPresenter.swift
//  Super easy dev
//
//  Created by Nikolay on 16.02.2025
//
import UIKit

enum SortType: Int {
    case none
    case name
    case nftCount
}

enum Key: String {
   case sortType
}

protocol NFTCollectionListPresenterProtocol: AnyObject {
    var numberOfNFTCollections: Int { get }
    func nftCollectionBusinessObjectForIndex(_ indexPath: IndexPath) -> NFTCollectionBusinessObject?
    func loadNextPageNFTCollectionList()
    func sortNftCollectionList(type: SortType)
    func showNftCollectionDetailForIndexPath(_ indexPath: IndexPath)
}

final class NFTCollectionListPresenter {

    // MARK: - Public Properties
    weak var view: NFTCollectionListViewProtocol?
    var router: NFTCollectionListRouterProtocol
    var interactor: NFTCollectionListInteractorProtocol

    // MARK: - Private Properties
    private var nftCollectionList: [NftCollection]? = []
    private var lastLoadedPage: Int?
    private let defaultPageSize = 10

    // MARK: - Initializers
    init(interactor: NFTCollectionListInteractorProtocol, router: NFTCollectionListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - NFTCollectionListPresenterProtocol
extension NFTCollectionListPresenter: NFTCollectionListPresenterProtocol {
    var numberOfNFTCollections: Int {
        nftCollectionList?.count ?? 0
    }

    func nftCollectionBusinessObjectForIndex(_ indexPath: IndexPath) -> NFTCollectionBusinessObject? {

        let nftCollection: NftCollection? = nftCollectionList?[indexPath.row]
        var imageURL: URL?
        if let imageURLString = nftCollection?.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            imageURL = URL(string: imageURLString)
        }
        let model = NFTCollectionBusinessObject(imageURL: imageURL,
                                           name: nftCollection?.name ?? "",
                                           nftCount: nftCollection?.nfts.count ?? 0)
        return model
    }

    func loadNextPageNFTCollectionList() {

        var nextPage: Int
        if let lastLoadedPage = lastLoadedPage {
            nextPage = lastLoadedPage + 1
        } else {
            nextPage = 0
            self.lastLoadedPage = 0
        }

        interactor.loadNftCollectionList(page: nextPage, size: defaultPageSize) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nftCollectionList):
                self.nftCollectionList?.append(contentsOf: nftCollectionList)
                self.sortNftCollectionList(type: .none)
                self.view?.updateForNewData()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }

    func sortNftCollectionList(type: SortType) {

        var currentType = type
        if type == .none {
            let savedSortType = SortType(rawValue: LocalStorage.shared.getValue(for: Key.sortType.rawValue))
            if savedSortType == SortType.none {
                currentType = .nftCount
            } else if let savedSortType = savedSortType {
                currentType = savedSortType
            }
        }

        LocalStorage.shared.saveValue(currentType.rawValue, for: Key.sortType.rawValue)

        switch currentType {
        case .name:
            nftCollectionList = nftCollectionList?.sorted(by: { return $0.name < $1.name })
        case .nftCount:
            nftCollectionList = nftCollectionList?.sorted(by: { return $0.nfts.count < $1.nfts.count })
        default:
            break
        }

        view?.updateForNewData()
    }

    func showNftCollectionDetailForIndexPath(_ indexPath: IndexPath) {
        if let nftCollection = nftCollectionList?[indexPath.row] {
            let nftCollectionDetailInput = NftCollectionDetailInput(id: nftCollection.id)
            router.showNftCollectionDetail(nftCollectionDetailInput: nftCollectionDetailInput)
        }
    }
}

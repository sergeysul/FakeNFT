import Foundation

protocol NftFiltersProtocol {
    static func filterByPrice(nft: inout [Nft])
    static func filterByRating(nft: inout [Nft])
    static func filterByName(nft: inout [Nft])
}

final class NftFilters: NftFiltersProtocol {
    static func filterByPrice(nft: inout [Nft]) {
        nft.sort { $0.price > $1.price }
    }

    static func filterByRating(nft: inout [Nft]) {
        nft.sort { $0.rating > $1.rating}
    }

    static func filterByName(nft: inout [Nft]) {
        nft.sort { $0.name > $1.name}
    }
}

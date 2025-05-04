import Foundation

struct UpdateOrderDto: Dto {
    let nfts: [String]

    enum CodingKeys: String, CodingKey {
        case nfts
    }

    func asDictionary() -> [String: String] {
        let value = nfts.isEmpty ? "null" : nfts.joined(separator: ", ")
        return [CodingKeys.nfts.rawValue: value]
    }
}

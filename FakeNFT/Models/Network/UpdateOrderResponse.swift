import Foundation

struct UpdateOrderResponse: Decodable {
    let nfts: [String]
    let id: String
}

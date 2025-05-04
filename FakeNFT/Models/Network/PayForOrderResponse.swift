import Foundation

struct PayForOrderResponse: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}

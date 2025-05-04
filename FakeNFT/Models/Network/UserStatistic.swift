import Foundation

struct UserStatistic: Decodable {
    let name: String
    let avatar: String
    let nfts: [String]
    let id: String

    var nftCount: Int {
        nfts.count
    }
}

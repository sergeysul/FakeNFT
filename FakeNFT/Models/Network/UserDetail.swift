import Foundation

struct UserDetail: Decodable {
    let id: String
    let avatar: String
    let name: String
    let description: String
    let website: String
    let nfts: [String]

    var nftCount: Int {
        nfts.count
    }
}

struct UserDetails {
    let name: String
    let description: NSAttributedString
    let text: String
    let imageURL: URL?
}

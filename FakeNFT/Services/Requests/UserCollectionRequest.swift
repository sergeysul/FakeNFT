import Foundation

struct UserCollectionRequest: NetworkRequest {
    let nftId: String

    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)"
        return URL(string: urlString)
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

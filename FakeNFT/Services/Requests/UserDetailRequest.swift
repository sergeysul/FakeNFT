import Foundation

struct UserDetailRequest: NetworkRequest {
    let userId: String

    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/users/\(userId)"
        return URL(string: urlString)
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

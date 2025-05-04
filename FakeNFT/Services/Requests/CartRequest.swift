import Foundation

struct CartRequest: NetworkRequest {

    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/orders/1"
        return URL(string: urlString)
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

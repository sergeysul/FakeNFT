import Foundation

struct StatisticRequest: NetworkRequest {
    let page: Int
    let size: Int

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)")
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

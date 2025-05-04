import Foundation

struct RequestBuilder: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: (any Dto)?

    init(endpoint: URL?, httpMethod: HttpMethod, dto: (any Dto)? = nil) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.dto = dto
    }
}

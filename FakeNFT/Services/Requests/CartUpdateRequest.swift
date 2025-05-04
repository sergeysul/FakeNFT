import Foundation

struct CartUpdateRequest: NetworkRequest {
    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/orders/1"
        return URL(string: urlString)
    }

    var httpMethod: HttpMethod { .put }
    var dto: Dto?

    init(nfts: [String]) {
        self.dto = CartUpdateDto(nfts: nfts)
    }
}

struct CartUpdateDto: Dto {
    let nfts: [String]

    func asDictionary() -> [String: String] {
        if nfts.isEmpty {
            return [:]
        }
        let value = nfts.joined(separator: ", ")
        return ["nfts": value]
    }
}

import Foundation

struct NetworkRequests {
    static func getNFTInsideCart() -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1"),
            httpMethod: .get
        )
    }

    static func getNFTById(id: String) -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)"),
            httpMethod: .get
        )
    }

    static func getCurrencies() -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/currencies"),
            httpMethod: .get
        )
    }

    static func putOrder1(dto: Dto) -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1"),
            httpMethod: .put,
            dto: dto
        )
    }

    static func putProfile1(dto: Dto) -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1"),
            httpMethod: .put,
            dto: dto
        )
    }

    static func setCurrencyIdAndPay(id: String) -> NetworkRequest {
        RequestBuilder(
            endpoint: URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)"),
            httpMethod: .get
        )
    }
}

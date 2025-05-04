import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        return URL(string: urlString)
    }

    var httpMethod: HttpMethod { .put }
    var dto: Dto?

    init(likes: [String]) {
        self.dto = ProfileUpdateDto(likes: likes)
    }
}

struct ProfileUpdateDto: Dto {
    let likes: [String]

    func asDictionary() -> [String: String] {
        if likes.isEmpty {
            return [:]
        }
        let value = likes.joined(separator: ", ")
        return ["likes": value]
    }
}

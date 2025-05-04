//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 05.03.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        return URL(string: urlString)
    }

    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}

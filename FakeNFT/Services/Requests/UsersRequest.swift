//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 25.02.2025.
//

import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    var dto: Dto?
}

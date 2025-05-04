//
//  UserRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 20.02.2025.
//

import Foundation

struct UserRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
    var dto: Dto?
}

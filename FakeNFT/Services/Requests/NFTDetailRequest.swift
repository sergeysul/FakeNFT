//
//  NFTDetailRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 20.02.2025.
//

import Foundation

struct NFTDetailRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}

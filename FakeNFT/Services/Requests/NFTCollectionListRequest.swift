//
//  NFTCollectionListRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 17.02.2025.
//

import Foundation

struct NFTCollectionListRequest: NetworkRequest {
    let page: Int
    let size: Int
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections?page=\(page)&size=\(size)")
    }
    var dto: Dto?
}

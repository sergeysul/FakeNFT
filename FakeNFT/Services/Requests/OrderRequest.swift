//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 05.03.2025.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: Dto?
}

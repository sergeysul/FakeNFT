//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Nikolay on 20.02.2025.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    var dto: Dto?
}

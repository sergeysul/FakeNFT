//
//  User.swift
//  FakeNFT
//
//  Created by Nikolay on 20.02.2025.
//

import Foundation

struct User: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}

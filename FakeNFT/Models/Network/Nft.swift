//
//  Nft.swift
//  FakeNFT
//
//  Created by Nikolay on 20.02.2025.
//

import Foundation

struct Nft: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}

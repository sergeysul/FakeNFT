//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Nikolay on 17.02.2025.
//

import Foundation

struct NftCollection: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

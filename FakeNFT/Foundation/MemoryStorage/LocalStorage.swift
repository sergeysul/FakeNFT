//
//  LocalStorage.swift
//  FakeNFT
//
//  Created by Nikolay on 21.02.2025.
//

import Foundation

final class LocalStorage {

    private init() {}

    static let shared = LocalStorage()

    func saveValue(_ value: Any, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getValue(for key: String) -> Int {
        UserDefaults.standard.integer(forKey: key)
    }
}

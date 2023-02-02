//
//  KeyValueRepository.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import Foundation

protocol KeyValueRepository {
    func setValue(_ value: String, forKey key: String) async
    func getValue(forKey key: String) async -> String?
    func removeValue(forKey key: String) async -> String?
}

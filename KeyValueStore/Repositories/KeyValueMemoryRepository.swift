//
//  KeyValueMemoryRepository.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import Foundation

class KeyValueMemoryRepository: KeyValueRepository {
    
    private var dictionary = DictionaryThreadSafe()

    func setValue(_ value: String, forKey key: String) async {
        dictionary.setValue(value, forKey: key)
    }

    func getValue(forKey key: String) async -> String? {
        dictionary.getValue(forKey: key)
    }
    
    func removeValue(forKey key: String) async -> String? {
        dictionary.removeValue(forKey: key)
    }
}

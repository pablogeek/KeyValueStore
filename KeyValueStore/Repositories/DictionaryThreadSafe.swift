//
//  DictionaryThreadSafe.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 02/02/2023.
//

import Foundation

class DictionaryThreadSafe {
    
    private let queue = DispatchQueue(label: "keyvaluestore.dictionaryQueue")
    
    private var dictionary = [String: String]()
    
    func setValue(_ value: String, forKey key: String) {
        queue.sync {
            dictionary[key] = value
        }
    }

    func getValue(forKey key: String) -> String? {
        var result: String?
        queue.sync {
            result = dictionary[key]
        }
        return result
    }
    
    func removeValue(forKey key: String) -> String? {
        var result: String?
        queue.sync {
            result = dictionary.removeValue(forKey: key)
        }
        return result
    }
}

//
//  KeyValueTransactionsService.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import Foundation

class KeyValueTransactionsServiceImpl : KeyValueTransactionsService {
    
    let keyValueRepository: KeyValueRepository
    
    init(keyValueRepository: KeyValueRepository) {
        self.keyValueRepository = keyValueRepository
    }
    
    func commit(transaction: Transaction) async {
        await transaction.commands.asyncForEach {
             await singleCommand(command: $0)
        }
    }
    
    func singleCommand(command: Command) async {
        switch command {
        case let .set(key, value):
            await keyValueRepository.setValue(value, forKey: key)
        case let .delete(key):
            let _ = await keyValueRepository.removeValue(forKey: key)
        }
    }
    
    func getValue(key: String) async throws -> String {
        if let val = await keyValueRepository.getValue(forKey: key) {
            return val
        } else {
            throw KeyValueError.keyNotSet
        }
    }
}

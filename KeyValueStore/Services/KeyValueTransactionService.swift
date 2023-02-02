//
//  KeyValueTransactionService.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 02/02/2023.
//

import Foundation

protocol KeyValueTransactionsService {
    func commit(transaction: Transaction) async // Commits a transaction
    func singleCommand(command: Command) async // Sends a single command without any transaction
    func getValue(key: String) async throws -> String // Gets a value or returns an error if the key doesn't exist
}

enum KeyValueError: Error {
    case keyNotSet
}

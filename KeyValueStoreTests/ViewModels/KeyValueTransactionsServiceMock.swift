//
//  KeyValueTransactionsServiceMock.swift
//  KeyValueStoreTests
//
//  Created by Pablo Martinez Piles on 02/02/2023.
//

import Foundation
@testable import KeyValueStore

class KeyValueTransactionsServiceMock: KeyValueTransactionsService {
    
    @Published private(set) var commitCalled = false
    func commit(transaction: KeyValueStore.Transaction) async {
        commitCalled = true
    }
    
    @Published private(set) var singleCommandCalled = false
    func singleCommand(command: KeyValueStore.Command) async {
        singleCommandCalled = true
    }
    
    private(set) var getValueCalled: Bool = false
    var valueToReturn: String = ""
    func getValue(key: String) async throws -> String {
        getValueCalled = true
        return valueToReturn
    }
}

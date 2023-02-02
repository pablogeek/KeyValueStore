//
//  KeyValueTransactionsServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import XCTest
@testable import KeyValueStore

final class KeyValueTransactionsServiceTests: XCTestCase {
    
    var service: KeyValueTransactionsService!
    
    func test_okaySetGetValue() async {
        setupService()
        
        await service.singleCommand(command: .set(key: "a", value: "b"))
        do {
            let value = await try service.getValue(key: "a")
            XCTAssert(value == "b")
        } catch {
            XCTFail("The key value should exist")
        }
    }
    
    func test_transactions() async {
        setupService()
        
        let transaction = Transaction(
            commands: [
                .set(key: "a", value: "b"),
                .delete(key: "c"),
                .set(key: "c", value: "d"),
                .set(key: "p", value: "q"),
                .delete(key: "a"),
                .set(key: "a", value: "u")
            ])
        
        await service.commit(transaction: transaction)
        
        do {
            let a = try await service.getValue(key: "a")
            let p = try await service.getValue(key: "p")
            
            XCTAssert(a == "u")
            XCTAssert(p == "q")
        } catch {
            XCTFail("The key value should exist")
        }
    }
    
    func test_fail_no_key() async {
        setupService()
        
        await service.singleCommand(command: .set(key: "a", value: "b"))
        
        do {
            let _ = try await service.getValue(key: "b")
            XCTFail("should throw")
        } catch {
            if let keyValueError = error as? KeyValueError {
                XCTAssert(keyValueError == .keyNotSet)
            } else {
                XCTFail("Error should be KeyValueError type")
            }
        }
    }
    
    private func setupService() {
        service = KeyValueTransactionsServiceImpl(keyValueRepository: KeyValueMemoryRepository())
    }
}

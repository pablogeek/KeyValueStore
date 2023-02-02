//
//  KeyValueMemoryRepository.swift
//  KeyValueStoreTests
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import XCTest
@testable import KeyValueStore

final class KeyValueMemoryRepositoryTests: XCTestCase {
    
    func testAddValue() async throws {
        let keyValueMemoryRepo = KeyValueMemoryRepository()
        
        await keyValueMemoryRepo.setValue("a", forKey: "b")
        
        let value = await keyValueMemoryRepo.getValue(forKey: "b")
        
        XCTAssert(value == "a")
    }
    
    func testDeleteValue() async throws {
        let keyValueMemoryRepo = KeyValueMemoryRepository()
        
        await keyValueMemoryRepo.setValue("a", forKey: "b")
        
        let value = await keyValueMemoryRepo.getValue(forKey: "b")
        XCTAssert(value == "a")
        
        let valueRemoved = await keyValueMemoryRepo.removeValue(forKey: "b")
        
        XCTAssert(valueRemoved == "a")
    }
}

//
//  ContentViewModelTests.swift
//  KeyValueStoreTests
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import XCTest
@testable import KeyValueStore
import Combine

final class ContentViewModelTests: XCTestCase {
    
    var serviceMock: KeyValueTransactionsServiceMock!
    private var cancellable = Set<AnyCancellable>()
    
    override func tearDownWithError() throws {
        serviceMock = nil
        cancellable.removeAll()
    }
    
    func test_commitActionNotCalled() {
        let viewModel = setupViewModel()
        viewModel.commit()
        
        XCTAssert(serviceMock.commitCalled == false)
    }
    
    func test_commitActionSuccess() {
        let methodCallExpectation = XCTestExpectation()
        
        let viewModel = setupViewModel(initialState: .transaction(transaction: Transaction()))
        
        serviceMock.$commitCalled.sink { isCalled in
            if isCalled {
                methodCallExpectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.commit()
        
        wait(for: [methodCallExpectation], timeout: 2.0)
        
        XCTAssert(serviceMock.commitCalled == true)
    }
    
    func test_getValueAction() {
        let viewModel = setupViewModel()
        viewModel.sendCommand(inputCommand: .get)
        
        XCTAssert(serviceMock.getValueCalled == true)
    }
    
    func test_singleCommandAction() {
        let methodCallExpectation = XCTestExpectation()
        
        let viewModel = setupViewModel()
        
        serviceMock.$singleCommandCalled.sink { isCalled in
            if isCalled {
                methodCallExpectation.fulfill()
            }
        }
        .store(in: &cancellable)
        
        viewModel.sendCommand(inputCommand: .set)
        
        wait(for: [methodCallExpectation], timeout: 2.0)
        
        XCTAssert(serviceMock.singleCommandCalled == true)
    }
    
    private func setupViewModel(
        initialState: ContentViewModel.State = .singleCommand
    ) -> ContentViewModel {
        self.serviceMock = KeyValueTransactionsServiceMock()
        return ContentViewModel(keyValueTransactionsService: serviceMock, initialState: initialState)
    }
}

//
//  ContentViewModel.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    enum State {
        case transaction(transaction: Transaction)
        case singleCommand
    }
    
    let service: KeyValueTransactionsService
    
    init(
        keyValueTransactionsService: KeyValueTransactionsService,
        initialState: State = .singleCommand
    ) {
        self.service = keyValueTransactionsService
        self.state = initialState
    }
    
    @Published var commandText: String = ""
    
    @Published var commandViewModels: [InputCommandViewModel] = [
        .init(command: .set, inputTexts: ["", ""]),
        .init(command: .get, inputTexts: [""]),
        .init(command: .delete, inputTexts: [""])
    ]
    
    private var state: State
    
    private var currentTransaction: Transaction?
    
    func sendCommand(inputCommand: InputCommand) {
        guard let model = commandViewModels.first(where: { $0.command == inputCommand }) else {
            return
        }
        writeNewCommandLine(text: model.stringCommand)
        
        let inputs = model.inputTexts
        
        switch state {
        case .singleCommand:
            Task {
                switch model.command {
                case .set:
                    await service.singleCommand(command: .set(key: inputs.first!, value: inputs.last!))
                case .delete:
                    await service.singleCommand(command: .delete(key: inputs.first!))
                case .get:
                    do {
                        let value = try await service.getValue(key: inputs.first!)
                        await MainActor.run {
                            writeNewCommandLine(text: value, withAction: false)
                        }
                    } catch {
                        await MainActor.run {
                            handleError(error: error)
                        }
                    }
                }
            }
        case let .transaction(transaction):
            switch model.command {
            case .set:
                transaction.commands.append(.set(key: inputs.first!, value: inputs.last!))
            case .delete:
                transaction.commands.append(.delete(key: inputs.first!))
            case .get:
                Task {
                    do {
                        let value = try await service.getValue(key: inputs.first!)
                        await MainActor.run {
                            writeNewCommandLine(text: value, withAction: false)
                        }
                    } catch {
                        await MainActor.run {
                            handleError(error: error)
                        }
                    }
                }
            }
        }
        clearInputs()
    }
    
    func begin() {
        state = .transaction(transaction: Transaction())
        writeNewCommandLine(text: "BEGIN")
    }
    
    func rollback() {
        writeNewCommandLine(text: "ROLLBACK")
        
        switch state {
        case .singleCommand:
            writeNewCommandLine(text: "No transaction", withAction: false)
        case .transaction:
            state = .singleCommand
        }
    }
    
    func commit() {
        writeNewCommandLine(text: "COMMIT")
        switch state {
        case let .transaction(transaction):
            Task {
                await service.commit(transaction: transaction)
            }
        case .singleCommand:
            writeNewCommandLine(text: "No transaction", withAction: false)
        }
        
        state = .singleCommand
    }
    
    private func writeNewCommandLine(
        text: String,
        withAction: Bool = true
    ) {
        commandText.append("\n")
        if withAction {
            commandText.append("> \(text)")
        } else {
            commandText.append("\(text)")
        }
    }
    
    private func handleError(error: Error) {
        if let keyValueError = error as? KeyValueError {
            switch keyValueError {
            case .keyNotSet:
                writeNewCommandLine(text: "key not set", withAction: false)
            }
        }
    }
    
    private func clearInputs() {
        commandViewModels.forEach { model in
            model.inputTexts.enumerated().forEach { index, _ in
                model.inputTexts[index] = ""
            }
        }
    }
}

extension InputCommand: CaseIterable {
    
    var numOfInput: Int {
        switch self {
        case .set: return 2
        case .get, .delete:
            return 1
        }
    }
    
    var name: String {
        switch self {
        case .set: return "SET"
        case .get: return "GET"
        case .delete: return "DELETE"
        }
    }
}

enum InputCommand: Int {
    case set
    case get
    case delete
}

class InputCommandViewModel: ObservableObject, Identifiable {
    
    var id: Int {
        command.rawValue
    }
    
    init(command: InputCommand, inputTexts: [String]) {
        self.inputTexts = inputTexts
        self.command = command
    }
    
    @Published var inputTexts: [String] = []
    let command: InputCommand
    
    var stringCommand: String {
        "\(command.name) \(inputTexts.joined(separator: " "))"
    }
}

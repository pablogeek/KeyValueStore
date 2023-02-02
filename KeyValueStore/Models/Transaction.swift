//
//  Transaction.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import Foundation

class Transaction {
    var commands: [Command]
    
    init() {
        commands = []
    }
    
    init(commands: [Command]) {
        self.commands = commands
    }
}

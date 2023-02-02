//
//  Command.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import Foundation

enum Command {
    case set(key: String, value: String)
    case delete(key: String)
}

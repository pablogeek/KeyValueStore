//
//  KeyValueStoreApp.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 01/02/2023.
//

import SwiftUI

@main
struct KeyValueStoreApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(
                    keyValueTransactionsService: KeyValueTransactionsServiceImpl(
                        keyValueRepository: KeyValueMemoryRepository()
                    )
                )
            )
        }
    }
}

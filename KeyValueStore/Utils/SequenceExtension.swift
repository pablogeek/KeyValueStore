//
//  SequenceExtension.swift
//  KeyValueStore
//
//  Created by Pablo Martinez Piles on 02/02/2023.
//

import Foundation

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}

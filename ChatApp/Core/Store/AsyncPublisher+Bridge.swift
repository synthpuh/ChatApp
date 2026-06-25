//
//  AsyncPublisher+Bridge.swift
//  ChatApp
//
//  Created by Olga on 14.04.2026.
//

import Combine
import Foundation

extension Store {
    
    func observe<Value: Equatable>(
        _ keyPath: KeyPath<AppState, Value>
    ) -> AnyPublisher<Value, Never> {
        $state
            .map(keyPath)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

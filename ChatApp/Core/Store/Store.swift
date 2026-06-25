//
//  Store.swift
//  ChatApp
//
//  Created by Olga on 12.03.2026.
//

import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var state: AppState
    
    private let reducer: (AppState, ChatAction) -> AppState
    private var cancellables = Set<AnyCancellable>()
    
    init(
        initialState: AppState = AppState(),
        reducer: @escaping (AppState, ChatAction) -> AppState = chatReducer
    ) {
        self.state = initialState
        self.reducer = reducer
    }
    
    func dispatch(_ action: ChatAction) {
        state = reducer(state, action)
    }
}

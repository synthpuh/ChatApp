//
//  ChatReducerTests.swift
//  ChatApp
//
//  Created by Olga on 12.03.2026.
//

import Testing
@testable import ChatApp

@Suite("Chat Reducer Tests")
struct CharReducerTests {
    @Test("Loading state", arguments: [true, false])
    func setLoading(value: Bool) {
        let state = chatReducer(state: AppState(), action: .setLoading(value))
        #expect(state.isLoading == value)
    }
    
    @Test("Recieved message appends to list")
    func recieveMessage() {
        let message = Message(id: "1", text: "Hello", senderId: "u1", timestamp: .now)
        let state = chatReducer(state: AppState(), action: .recieveMessage(message))
        #expect(state.messages.count == 1)
        #expect(state.messages.first?.text == "Hello")
    }
    
    @Test("Clear messages empties list")
    func clearMessages() {
        let message = Message(id: "1", text: "Hello", senderId: "u1", timestamp: .now)
        var initial = AppState()
        initial.messages = [message]
        let state = chatReducer(state: initial, action: .clearMessages)
        #expect(state.messages.isEmpty)
    }
}

@Suite("Store tests")
@MainActor
struct StoreTests {
    
    @Test("Dispatch updates state")
    func dispatchUpdatesState() {
        let store = Store(initialState: AppState())
        let message = Message(id: "1", text: "Hello", senderId: "u1", timestamp: .now)
        store.dispatch(.recieveMessage(message))
        #expect(store.state.messages.count == 1)
    }
    
    @Test("Store publishes state changes via Combine")
    func storePublishesChanges() async {
        let store = Store(initialState: AppState())
        let message = Message(id: "1", text: "Hello", senderId: "u1", timestamp: .now)
        
        var recievedStates: [AppState] = []
        let cancellables = store.$state.sink { recievedStates.append($0) }
        
        store.dispatch(.recieveMessage(message))
        
        #expect(recievedStates.count == 2)
        #expect(recievedStates.last?.messages.count == 1)
        cancellables.cancel()
    }
}

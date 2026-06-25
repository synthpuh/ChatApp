//
//  ChatInteractorIntegrationTests.swift
//  ChatApp
//
//  Created by Olga on 21.05.2026.
//

import Testing
import Combine
@testable import ChatApp

@Suite("Chat Interactor Integration", .tags(.integration))
@MainActor
struct ChatInteractorIntegrationTests {
    
    private func makeSUT() -> (
        interactor: ChatInteractor,
        store: Store,
        service: MockChatService
    ) {
        let store = Store()
        let service = MockChatService()
        let interactor = ChatInteractor(store: store, service: service)
        return (interactor, store, service)
    }
    
    @Test("Fetch messages updates store state")
    func fetchMessagesUpdatesStore() async {
        let (interactor, store, service) = makeSUT()
        service.mockMessages = [
            Message(id: "1", text: "Hello", senderId: "u1", timestamp: .now),
            Message(id: "2", text: "World", senderId: "u2", timestamp: .now)
        ]
        
        await interactor.fetchMessages()
        
        #expect(store.state.messages.count == 2)
        #expect(store.state.isLoading == false)
    }
    
    @Test("Fetch messages sets loading state correctly")
    func fetchMessagesSetsLoadingState() async {
        let (interactor, store, service) = makeSUT()
        service.mockMessages = []
        
        #expect(store.state.isLoading == false)
        await interactor.fetchMessages()
        #expect(store.state.isLoading == false)
    }
    
    @Test("Fetch messages sets error on failure")
    func fetchMessagesHandlesError() async {
        let (interactor, store, service) = makeSUT()
        service.shouldThrow = true
        
        await interactor.fetchMessages()
        
        #expect(store.state.error != nil)
        #expect(store.state.isLoading == false)
    }
    
    @Test("Send message appends to store")
    func sendMessageAppendsToStore() async {
        let (interactor, store, _) = makeSUT()
        store.dispatch(.setCurrentUser(User(id: "me", name: "Test User")))
        
        await interactor.sendMessage("Hello!")
        
        #expect(store.state.messages.count == 1)
        #expect(store.state.messages.first?.text == "Hello!")
    }
    
    @Test("Observe messages streams pushed message into store")
    func observeMessagesStreamsIntoStore() async throws {
        let (interactor, store, service) = makeSUT()
        
        await interactor.startObservingMessages()
        try await Task.sleep(for: .milliseconds(50))
        
        service.simulateIncoming(Message(id: "1",
                                         text: "Streamed",
                                         senderId: "u1",
                                         timestamp: .now))
        
        try await Task.sleep(for: .milliseconds(50))
        interactor.stopObservingMessages()
        
        #expect(store.state.messages.contains { $0.text == "Streamed" })
    }
}

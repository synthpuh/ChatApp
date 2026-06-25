//
//  ChatPresenterCombineTests.swift
//  ChatApp
//
//  Created by Olga on 14.04.2026.
//

import Testing
import Combine
@testable import ChatApp

@Suite("Presenter Combine Bindings")
@MainActor
struct ChatPresenterCombineTests {
    
    @Test("Store message changes reach the view")
    func messagesReachView() async throws {
        let store = Store(initialState: .init())
        let interactor = MockChatInteractor()
        let view = MockChatView()
        let presenter = ChatPresenter(
            interactor: interactor,
            router: MockChatRouter(),
            store: store)
        
        presenter.view = view
        presenter.viewDidLoad()
        
        let message = Message(
            id: "1",
            text: "Hello",
            senderId: "me",
            timestamp: .now)
        
        store.dispatch(.recieveMessage(message))
        
        try await Task.sleep(for: Duration.milliseconds(100))
        
        #expect(view.receivedMessages?.count == 1)
        #expect(view.receivedMessages?.first?.text == "Hello")
    }
    
    @Test("Loading state reaches view")
    func loadingReachesView() async throws {
        let store = Store(initialState: .init())
        let view = MockChatView()
        let presenter = ChatPresenter(
            interactor: MockChatInteractor(),
            router: MockChatRouter(),
            store: store)
        
        presenter.view = view
        presenter.viewDidLoad()
        
        store.dispatch(.setLoading(true))
        try await Task.sleep(for: Duration.milliseconds(100))
        
        #expect(view.isLoading == true)
    }
    
    @Test("Cancellables cleared on viewDidDisappear")
    func cancellablesCleared() async throws {
        let store = Store(initialState: .init())
        let view = MockChatView()
        let presenter = ChatPresenter(
            interactor: MockChatInteractor(),
            router: MockChatRouter(),
            store: store)
        
        presenter.view = view
        presenter.viewDidLoad()
        presenter.viewDidDisappear()
        
        let message = Message(id: "1", text: "Hello", senderId: "me", timestamp: .now)
        store.dispatch(.recieveMessage(message))
        try await Task.sleep(for: Duration.milliseconds(100))
        
        #expect(view.receivedMessages == nil)
    }
}

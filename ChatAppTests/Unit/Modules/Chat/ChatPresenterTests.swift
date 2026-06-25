//
//  ChatPresenterTests.swift
//  ChatApp
//
//  Created by Olga on 26.05.2026.
//

import Testing
import Combine

@testable import ChatApp

@Suite("Chat Presenter")
@MainActor
struct ChatPresenterTests {
    
    @Test("viewDidLoad triggers fetch and observation")
    func viewDidLoadTriggersFetch() async throws {
        let interactor = MockChatInteractor()
        let presenter = ChatPresenter(interactor: interactor,
                                      router: MockChatRouter(),
                                      store: Store())
        presenter.viewDidLoad()
        try await Task.sleep(for: .milliseconds(100))
        #expect(interactor.fetchMessagesCalled)
        #expect(interactor.startObservinfCalled)
    }
    
    @Test("didTapSend ignores empty text")
    func sendIgnoresEmptyText() async throws {
        let interactor = MockChatInteractor()
        let presenter = ChatPresenter(interactor: interactor,
                                      router: MockChatRouter(),
                                      store: Store())
        presenter.didTapSend(text: "   ")
        try await Task.sleep(for: .milliseconds(100))
        #expect(interactor.sendMessageCalled == false)
    }
    
    @Test("didTapSend forwards valid text to interactor")
    func sendForwardsValidText() async throws {
        let interactor = MockChatInteractor()
        let presenter = ChatPresenter(interactor: interactor,
                                      router: MockChatRouter(),
                                      store: Store())
        presenter.didTapSend(text: "Hello")
        try await Task.sleep(for: .milliseconds(100))
        #expect(interactor.sendMessageCalled)
        #expect(interactor.lastSentText == "Hello")
    }
    
    @Test("didTapUserProfile navigates via router")
    func profileNavigates() {
        let router = MockChatRouter()
        let presenter = ChatPresenter(interactor: MockChatInteractor(),
                                      router: router,
                                      store: Store())
        presenter.didTapUserProfile(userId: "u1")
        #expect(router.navigateToUserProfileCalled)
    }
}

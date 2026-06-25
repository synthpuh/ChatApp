//
//  MockChatInteractor.swift
//  ChatApp
//
//  Created by Olga on 15.04.2026.
//

final class MockChatInteractor: ChatInteractorProtocol {
    
    var fetchMessagesCalled = false
    var sendMessageCalled = false
    var startObservinfCalled = false
    var stopObservingCalled = false
    
    var lastSentText: String?
    var isObserving = false
    
    func fetchMessages() async {
        fetchMessagesCalled = true
    }
    
    func sendMessage(_ text: String) async {
        sendMessageCalled = true
        lastSentText = text
    }
    
    func startObservingMessages() async {
        startObservinfCalled = true
        isObserving = true
    }
    
    func stopObservingMessages() {
        stopObservingCalled = true
        isObserving = false
    }
}

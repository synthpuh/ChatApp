//
//  MockChatView.swift
//  ChatApp
//
//  Created by Olga on 15.04.2026.
//

class MockChatView: ChatViewProtocol {
    
    var receivedMessages: [ChatMessageViewModel]?
    var isLoading: Bool?
    var receivedError: String?
    
    func showMessages(_ viewModels: [ChatMessageViewModel]) {
        receivedMessages = viewModels
    }
    
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func showError(_ message: String) {
        receivedError = message
    }
}

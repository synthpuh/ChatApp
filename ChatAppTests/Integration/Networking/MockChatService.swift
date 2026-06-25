//
//  MockChatService.swift
//  ChatApp
//
//  Created by Olga on 14.03.2026.
//

import Foundation

class MockChatService: ChatServiceProtocol {
    
    var mockMessages: [Message] = []
    var shouldThrow: Bool = false
    
    private var continuation: AsyncThrowingStream<Message, Error>.Continuation?
    
    func fetchMessages() async throws -> [Message] {
        if shouldThrow {
            throw ChatError.networkUnavailable
        }
        return mockMessages
    }
    
    func sendMessage(_ text: String, senderId: String) async throws -> Message {
        if shouldThrow {
            throw ChatError.sendFailed
        }
        let message = Message(
            id: UUID().uuidString,
            text: text,
            senderId: senderId,
            timestamp: .now
        )
        return message
    }
    
    func observeMessages() -> AsyncThrowingStream<Message, any Error> {
        AsyncThrowingStream { continuation in
            self.continuation = continuation
        }
    }
    
    func simulateIncoming(_ message: Message) {
        continuation?.yield(message)
    }
}

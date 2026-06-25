//
//  MockChatServiceTests.swift
//  ChatApp
//
//  Created by Olga on 14.03.2026.
//

import Testing
@testable import ChatApp

@Suite("Mock chat service")
struct MockChatServiceTests {
    @Test("Fetch returns messages")
    func fetchMessages() async throws {
        let service = MockChatService()
        service.mockMessages = [
            Message(id: "1",
                    text: "Hello",
                    senderId: "u1",
                    timestamp: .now)
        ]
        let messages = try await service.fetchMessages()
        #expect(messages.count == 1)
        #expect(messages.first?.text == "Hello")
    }
    
    @Test("Send returns the created message")
    func sendMessage() async throws {
        let service = MockChatService()
        let sent = try await service.sendMessage("Hello", senderId: "u1")
        #expect(sent.text == "Hello")
        #expect(sent.senderId == "u1")
    }
    
    @Test("Throws when shouldThrow is true")
    func throwsOnError() async {
        let service = MockChatService()
        service.shouldThrow = true
        await #expect(throws: ChatError.networkUnavailable) {
            try await service.fetchMessages()
        }
    }
}

//
//  ChatServiceIntegrationTests.swift
//  ChatApp
//
//  Created by Olga on 14.03.2026.
//

import Testing
import Alamofire
import Foundation
@testable import ChatApp

@Suite("Chat service integration", .tags(.integration))
struct ChatServiceIntegrationTests {
    
    @Test("Fetch messages from real endpoint")
    func fetchMessages() async throws {
        let service = ChatServiceImpl(baseUrl: "http://localhost:8080", connection: ConnectionManager(url: URL(string: "http://localhost:8080")!))
        let messages = try await service.fetchMessages()
        #expect(messages.isEmpty == false)
    }
    
    @Test("Send message returns sent message")
    func sendMessage() async throws {
        let service = ChatServiceImpl(baseUrl: "Http://localhost:8080", connection: ConnectionManager(url: URL(string: "http://localhost:8080")!))
        let message = try await service.sendMessage("Integration test", senderId: "u1")
        #expect(message.text == "Integration test")
    }
}

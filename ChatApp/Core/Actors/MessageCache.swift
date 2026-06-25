//
//  MessageCache.swift
//  ChatApp
//
//  Created by Olga on 19.03.2026.
//

import Foundation

actor MessageCache {
    
    private var messages: [Message] = []
    
    //MARK: - Read
    
    func all() -> [Message] {
        messages
    }
    
    func message(withId id: String) -> Message? {
        messages.first { $0.id == id }
    }
    
    //MARK: - Write
    
    func append(_ message: Message) {
        guard !messages.contains(where: { $0.id == message.id }) else { return }
        messages.append(message)
    }
    
    func append(contentsOf newMessages: [Message]) {
        for message in newMessages {
            append(message)
        }
    }
    
    func clear() {
        messages = []
    }
    
    func replace(with newMessages: [Message]) {
        messages = newMessages
    }
}

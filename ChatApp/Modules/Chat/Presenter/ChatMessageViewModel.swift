//
//  ChatMessageViewModel.swift
//  ChatApp
//
//  Created by Olga on 20.03.2026.
//

import Foundation

struct ChatMessageViewModel: Equatable {
    let id: String
    let text: String
    let senderName: String
    let timestamp: String
    let isOutgoing: Bool
    
    init(message: Message, currentUserId: String? = "me") {
        self.id = message.id
        self.text = message.text
        self.senderName = message.senderId
        self.timestamp = Self.formatted(message.timestamp)
        self.isOutgoing = message.senderId == currentUserId
    }
    
    private static func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

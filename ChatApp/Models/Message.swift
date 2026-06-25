//
//  Message.swift
//  ChatApp
//
//  Created by Olga on 12.03.2026.
//

import Foundation

struct Message: Equatable, Identifiable, Codable {
    let id: String
    let text: String
    let senderId: String
    let timestamp: Date
}

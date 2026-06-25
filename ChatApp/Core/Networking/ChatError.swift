//
//  ChatError.swift
//  ChatApp
//
//  Created by Olga on 14.03.2026.
//

enum ChatError: Error, Equatable {
    case networkUnavailable
    case sendFailed
    case decodingFailed
    case unauthorized
}

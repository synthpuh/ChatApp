//
//  AppState.swift
//  ChatApp
//
//  Created by Olga on 12.03.2026.
//

struct AppState: Equatable {
    var messages: [Message] = []
    var currentUser: User? = nil
    var isLoading: Bool = false
    var error: String? = nil
}

//
//  ChatAction.swift
//  ChatApp
//
//  Created by Olga on 12.03.2026.
//

enum ChatAction: Equatable {
    case sendMessage(String)
    case recieveMessage(Message)
    case setLoading(Bool)
    case setError(String)
    case clearMessages
    case setCurrentUser(User)
}

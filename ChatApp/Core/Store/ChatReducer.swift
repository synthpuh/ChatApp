//
//  ChatReducer.swift
//  ChatApp
//
//  Created by Olga on 12.03.2026.
//

func chatReducer(state: AppState, action: ChatAction) -> AppState {
    var state = state
    switch action {
    case .sendMessage:
        state.isLoading = true
    case .recieveMessage(let message):
        state.messages.append(message)
        state.isLoading = false
    case .setLoading(let bool):
        state.isLoading = bool
    case .setError(let string):
        state.error = string
        state.isLoading = false
    case .clearMessages:
        state.messages = []
    case .setCurrentUser(let user):
        state.currentUser = user
    }
    return state
}

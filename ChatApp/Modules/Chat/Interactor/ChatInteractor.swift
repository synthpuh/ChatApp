//
//  ChatInteractor.swift
//  ChatApp
//
//  Created by Olga on 20.03.2026.
//

import Foundation
import Combine

protocol ChatInteractorProtocol: AnyObject {
    func fetchMessages() async
    func sendMessage(_ text: String) async
    func startObservingMessages() async
    func stopObservingMessages()
}

final class ChatInteractor: ChatInteractorProtocol {
    
    weak var presenter: ChatPresenterProtocol?
    
    private let store: Store
    private let service: ChatServiceProtocol
    private var observationTask: Task<Void, Never>?
    
    init(store: Store, service: any ChatServiceProtocol) {
        self.store = store
        self.service = service
    }
    
    func fetchMessages() async {
        await store.dispatch(.setLoading(true))
        do {
            let messages = try await service.fetchMessages()
            for message in messages {
                await store.dispatch(.recieveMessage(message))
            }
            await store.dispatch(.setLoading(false))
        } catch {
            await store.dispatch(.setError(error.localizedDescription))
        }
    }
    
    func sendMessage(_ text: String) async {
        print("sendMessageCalled with \(text)")
        guard let currentUser = await store.state.currentUser else {
            print("No current user - bailing")
            return
        }
        print("Sending as: \(currentUser.id)")
        do {
            let message = try await service.sendMessage(text, senderId: currentUser.id)
            await store.dispatch(.recieveMessage(message))
        } catch {
            await store.dispatch(.setError(error.localizedDescription))
        }
    }
    
    func startObservingMessages() async {
        observationTask = Task {
            do {
                for try await message in service.observeMessages() {
                    await store.dispatch(.recieveMessage(message))
                }
            } catch {
                await store.dispatch(.setError(error.localizedDescription))
            }
        }
    }
    
    func stopObservingMessages() {
        observationTask?.cancel()
        observationTask = nil
    }
}

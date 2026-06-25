//
//  ConnectionManager.swift
//  ChatApp
//
//  Created by Olga on 19.03.2026.
//

import Foundation

actor ConnectionManager {
    
    enum ConnectionState: Equatable {
        case disconnected
        case connecting
        case connected
        case failed(String)
    }
    
    private(set) var state: ConnectionState = .disconnected
    private var websocketTask: URLSessionWebSocketTask?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    //MARK: - Connect
    
    func connect() async {
        guard state == .disconnected else { return }
        state = .connecting
        
        let session = URLSession.shared
        websocketTask = session.webSocketTask(with: url)
        websocketTask?.resume()
        state = .connected
    }
    
    //MARK: - Disconnect
    
    func disconnect() async {
        websocketTask?.cancel(with: .goingAway, reason: nil)
        websocketTask = nil
        state = .disconnected
    }
    
    //MARK: - Send
    
    func send(_ text: String) async throws {
        guard state == .connected, let task = websocketTask else {
            throw ChatError.networkUnavailable
        }
        try await task.send(.string(text))
    }
    
    //MARK: - Recieve stream
    
    func recieveMessages() -> AsyncThrowingStream<Message, Error> {
        AsyncThrowingStream { continuation in
            Task {
                while self.state == .connected, let task = self.websocketTask {
                    do {
                        let result = try await task.receive()
                        switch result {
                        case .data(let data):
                            if let message = try? JSONDecoder().decode(Message.self, from: data) {
                                continuation.yield(message)
                            }
                        case .string(let string):
                            if let data = string.data(using: .utf8), let message = try? JSONDecoder().decode(Message.self, from: data) {
                                continuation.yield(message)
                            }
                        @unknown default: break
                        }
                    } catch {
                        continuation.finish(throwing: error)
                        return
                    }
                }
                continuation.finish()
            }
        }
    }
}

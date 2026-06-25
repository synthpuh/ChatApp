//
//  ChatService.swift
//  ChatApp
//
//  Created by Olga on 14.03.2026.
//

import Alamofire

protocol ChatServiceProtocol {
    func fetchMessages() async throws -> [Message]
    func sendMessage(_ text: String, senderId: String) async throws -> Message
    func observeMessages() -> AsyncThrowingStream<Message, Error>
}

class ChatServiceImpl: ChatServiceProtocol {
    
    private let baseUrl: String
    private let session: Session
    private let cache: MessageCache
    private let connection: ConnectionManager
    
    init(baseUrl: String,
         session: Session = .default,
         cache: MessageCache = MessageCache(),
         connection: ConnectionManager
    ) {
        self.baseUrl = baseUrl
        self.session = session
        self.cache = cache
        self.connection = connection
    }
    
    func fetchMessages() async throws -> [Message] {
        
        do {
            let messages = try await session.request("\(baseUrl)/messages", method: .get)
                .validate()
                .serializingDecodable([Message].self)
                .value
            await cache.replace(with: messages)
            return await cache.all()
        } catch {
            throw mapError(error)
        }
    }
    
    func sendMessage(_ text: String, senderId: String) async throws -> Message {
        
        struct SendBody: Encodable {
            let text: String
            let senderId: String
        }
        
        do {
            let message = try await session.request("\(baseUrl)/messages",
                                             method: .post,
                                             parameters: SendBody(text: text, senderId: senderId),
                                             encoder: JSONParameterEncoder.default
            )
            .validate()
            .serializingDecodable(Message.self)
            .value
            await cache.append(message)
            return message
        } catch {
            throw mapError(error)
        }
    }
    
    func observeMessages() -> AsyncThrowingStream<Message, any Error> {
        
        AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }
    
    private func mapError(_ error: Error) -> ChatError {
        
        guard let afError = error as? AFError else { return .networkUnavailable }
        
        switch afError {
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason, code == 401 {
                return .unauthorized
            }
            return .networkUnavailable
        case .responseSerializationFailed(let reason):
            return .decodingFailed
        default:
            return .networkUnavailable
        }
    }
}

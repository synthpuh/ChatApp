//
//  MessageCacheTests.swift
//  ChatApp
//
//  Created by Olga on 19.03.2026.
//

import Testing
@testable import ChatApp

@Suite("MessageCache Actor")
struct MessageCacheTests {
    
    @Test("Append adds message")
    func appendMessage() async {
        let cache = MessageCache()
        let message = Message(id: "1",
                              text: "Hello",
                              senderId: "u1",
                              timestamp: .now)
        await cache.append(message)
        let all = await cache.all()
        #expect(all.count == 1)
    }
    
    @Test("Append ignores duplicates")
    func appendDuplicate() async {
        let cache = MessageCache()
        let message = Message(id: "1",
                              text: "Hello",
                              senderId: "u1",
                              timestamp: .now)
        await cache.append(message)
        await cache.append(message)
        let all = await cache.all()
        #expect(all.count == 1)
    }
    
    @Test("Clear empties cache")
    func clearCache() async {
        let cache = MessageCache()
        let message = Message(id: "1",
                              text: "Hello",
                              senderId: "u1",
                              timestamp: .now)
        await cache.append(message)
        await cache.clear()
        let all = await cache.all()
        #expect(all.isEmpty)
    }
    
    @Test("Concurrent appends are safe")
    func concurrentAppends() async {
        let cache = MessageCache()
        await withTaskGroup(of: Void.self) { group in
            for i in 1...100 {
                group.addTask {
                    let message = Message(id: "\(i)",
                                          text: "Hello",
                                          senderId: "u1",
                                          timestamp: .now)
                    await cache.append(message)
                }
            }
        }
        let all = await cache.all()
        #expect(all.count == 100)
    }
}

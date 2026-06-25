//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Olga on 12.03.2026.
//

import XCTest

final class ChatAppUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    // MARK: - Message List
    func testMessageListIsVisible() {
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 3))
    }
    
    func testMessagesAppearOnLoad() {
        let firstCell = app.tables.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 3))
    }
    
    // MARK: - Sending Messages
    func testSendButtonDisabledWhenEmpty() {
        let sendButton = app.buttons["SendButton"]
        XCTAssertTrue(sendButton.waitForExistence(timeout: 3))
        XCTAssertFalse(sendButton.isEnabled)
    }
    
    func testTypingEnablesSendButton() {
        let textView = app.textViews["MessageInput"]
        let sendButton = app.buttons["SendButton"]
        
        XCTAssertTrue(textView.waitForExistence(timeout: 3))
        textView.tap()
        textView.typeText("Hello!")
        
        XCTAssertTrue(sendButton.isEnabled)
    }
    
    func testSendingMessageAppearsInList() {
        let textView = app.textViews["MessageInput"]
        let sendButton = app.buttons["SendButton"]
        
        textView.tap()
        textView.typeText("Hello from UI test!")
        sendButton.tap()
        
        let message = app.staticTexts["Hello from UI test!"]
        XCTAssertTrue(message.waitForExistence(timeout: 3))
    }
    
    func testInputClearsAfterSend() {
        let textView = app.textViews["MessageInput"]
        let sendButton = app.buttons["SendButton"]
        
        textView.tap()
        textView.typeText("Test message")
        sendButton.tap()
        
        let value = textView.value as? String ?? ""
        XCTAssertNotEqual(value, "Test message")
    }
}

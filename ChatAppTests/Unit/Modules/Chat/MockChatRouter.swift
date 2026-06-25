//
//  MockChatRouter.swift
//  ChatApp
//
//  Created by Olga on 15.04.2026.
//

final class MockChatRouter: ChatRouterProtocol {
    
    var navigateToUserProfileCalled = false
    var dismissCalled = false
    
    var currentUserProfile: String?
    
    func navigateToUserProfile(userId: String) {
        navigateToUserProfileCalled = true
        currentUserProfile = userId
    }
    
    func dismiss() {
        dismissCalled = true
        currentUserProfile = nil
    }
}

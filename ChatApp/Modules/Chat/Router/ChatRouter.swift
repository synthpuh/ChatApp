//
//  ChatRouter.swift
//  ChatApp
//
//  Created by Olga on 20.03.2026.
//

import UIKit

protocol ChatRouterProtocol: AnyObject {
    func navigateToUserProfile(userId: String)
    func dismiss()
}

final class ChatRouter: ChatRouterProtocol {
    
    weak var viewController: UIViewController?
    
    @MainActor static func build(store: Store, service: any ChatServiceProtocol) -> UIViewController {
        let router = ChatRouter()
        let interactor = ChatInteractor(store: store, service: service)
        let presenter = ChatPresenter(interactor: interactor, router: router, store: store)
        let view = ChatViewController(presenter: presenter)
        
        router.viewController = view
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToUserProfile(userId: String) {
        
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

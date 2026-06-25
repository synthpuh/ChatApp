//
//  ChatPresenter.swift
//  ChatApp
//
//  Created by Olga on 20.03.2026.
//

import Foundation
import Combine

@MainActor
protocol ChatPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidDisappear()
    func didTapSend(text: String)
    func didTapUserProfile(userId: String)
}

@MainActor
final class ChatPresenter: ChatPresenterProtocol {
    
    weak var view: ChatViewProtocol?
    
    private let interactor: any ChatInteractorProtocol
    private let router: any ChatRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    private let store: Store
    
    init(interactor: any ChatInteractorProtocol,
         router: any ChatRouterProtocol,
         store: Store) {
        self.interactor = interactor
        self.router = router
        self.store = store
    }
    
    //MARK: - Bind store
    
    func bindStore() {
        bindMessages()
        bindLoadingState()
        bindErrors()
    }
    
    private func bindMessages() {
        store.observe(\.messages)
            .map { [weak self] messages -> [ChatMessageViewModel] in
                guard let currentUserId = self?.store.state.currentUser?.id else {
                    return messages.map { ChatMessageViewModel(message: $0, currentUserId: "") }
                }
                return messages.map { ChatMessageViewModel(message: $0, currentUserId: currentUserId) }
            }
            .sink { [weak self] viewModels in
                self?.view?.showMessages(viewModels)
            }
            .store(in: &cancellables)
    }
    
    private func bindLoadingState() {
        store.observe(\.isLoading)
            .removeDuplicates()
            .sink { [weak self] isLoading in
                self?.view?.setLoading(isLoading)
            }
            .store(in: &cancellables)
    }
    
    private func bindErrors() {
        store.observe(\.error)
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.view?.showError(error)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - ChatPresenterProtocol
    
    func viewDidLoad() {
        bindStore()
        Task { await interactor.fetchMessages() }
        Task { await interactor.startObservingMessages() }
    }
    
    func viewDidDisappear() {
        interactor.stopObservingMessages()
        cancellables.removeAll()
    }
    
    func didTapSend(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        Task { await interactor.sendMessage(text) }
    }
    
    func didTapUserProfile(userId: String) {
        router.navigateToUserProfile(userId: userId)
    }
}

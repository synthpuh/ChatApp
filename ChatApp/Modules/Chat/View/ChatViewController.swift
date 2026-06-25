//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Olga on 20.03.2026.
//

import UIKit
import Combine

protocol ChatViewProtocol: AnyObject {
    func showMessages(_ viewModels: [ChatMessageViewModel])
    func setLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

final class ChatViewController: UIViewController {
    
    //MARK: - Properties
    
    private let presenter: any ChatPresenterProtocol
    private var messages: [ChatMessageViewModel] = []
    
    //MARK: - UI
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseID)
        table.dataSource = self
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var inputBar: ChatInputBar = {
        let bar = ChatInputBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.onSend = { [weak self] text in
            self?.presenter.didTapSend(text: text)
        }
        return bar
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    //MARK: - Init
    
    init(presenter: any ChatPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
    
    //MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = activityIndicator
        
        tableView.accessibilityIdentifier = "MessageList"
        
        view.addSubview(tableView)
        view.addSubview(inputBar)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputBar.topAnchor),
            
            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBar.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

//MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {
    
    func showMessages(_ viewModels: [ChatMessageViewModel]) {
        messages = viewModels
        tableView.reloadData()
        guard !messages.isEmpty else { return }
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0),
                              at: .bottom,
                              animated: true)
    }
    
    func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.reuseID, for: indexPath) as! ChatMessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

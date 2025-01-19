//
//  ViewController.swift
//  AIMessaging
//
//  Created by HAKAN on 27.12.2024.
//

import UIKit
import GoogleGenerativeAI



class ViewController: UIViewController {
    
    private var messages: [Message] = [] {
           didSet {
               tableView.reloadData()
               scrolltoBottom()
           }
       }
    
    
    fileprivate let model = GenerativeModel(name: "gemini-pro",
                                        apiKey: "AIzaSyAv9okKK7aBWG7Y97opzbuLp5XJMUFRtfw")
    
    //MARK: - Properties
    let textfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Send message..."
        textField.font = .systemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .send
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let sendButton: UIButton = {
        
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .large)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.up", withConfiguration: config), for: .normal)
        button.tintColor = .blue
        button.backgroundColor = .green
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        return view
    }()
    
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.tableHeaderView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UserTextTableViewCell.self, forCellReuseIdentifier: UserTextTableViewCell.id)
        view.register(AITextTableViewCell.self, forCellReuseIdentifier: AITextTableViewCell.id)
        view.separatorStyle = .none
        return view
    }()
    
    
    private var bottomConstraint: NSLayoutConstraint?
    private var isWAitingForREsponse: Bool = false
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUI()
        configureTableView()
        setupKeyboardNotifications()
        setActions()
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //    MARK: - UI setup
    private func setUI() {
        
        let headerView = HomeHeaderView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 300))
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        footerView.addSubview(textfield)
        footerView.addSubview(sendButton)
        
        bottomConstraint = footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            
            footerView.heightAnchor.constraint(equalToConstant: 70),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomConstraint!,
            
            textfield.leftAnchor.constraint(equalTo: footerView.leftAnchor,constant: 15),
            textfield.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 50),
            
            sendButton.leftAnchor.constraint(equalTo: textfield.rightAnchor, constant: 10),
            sendButton.topAnchor.constraint(equalTo: textfield.topAnchor, constant: 0),
            sendButton.bottomAnchor.constraint(equalTo: textfield.bottomAnchor),
            sendButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            sendButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setActions() {
        textfield.delegate = self
        sendButton.addTarget(self, action: #selector(didTapToSend), for: .allTouchEvents)
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc private func scrolltoBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
    }
    
    @objc private func didTapToSend() {
        guard let text = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !text.isEmpty,
        !isWAitingForREsponse
        else { return }
        
        isWAitingForREsponse = true
        textfield.text = ""
        
        messages.append(Message(content: text, isFromUser: true))
        
        Task {
            do {
                let response = try await model.generateContent(text)
                await MainActor.run {
                    messages.append(Message(content: response.text ?? "Sorry, I couldn't generate a response", isFromUser: false))
                    isWAitingForREsponse = false
                }
            } catch {
                await MainActor.run {
                    messages.append(Message(content: "Sorry, an error occurred. Please try again.", isFromUser: false))
                    isWAitingForREsponse = false
                }
            }
        }
    }

    
    
    
    
    
    //MARK: - Keyboard Handling
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        bottomConstraint?.constant = -keyboardHeight
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double else { return }
        
        bottomConstraint?.constant = 0
       
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
   
    
   
    
   
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTextTableViewCell.id, for: indexPath) as? UserTextTableViewCell else { return UITableViewCell()}
            cell.configure(with: "Your message: \(message.content)")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AITextTableViewCell.id, for: indexPath) as? AITextTableViewCell else { return UITableViewCell()}
            cell.configure(with: "AI message: \(message.content)")
            return cell
        }
      
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}


extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Send a message ..."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapToSend()
        tableView.reloadData()
        return true
    }
}

//#Preview{
//    ViewController()
//}

//
//  ChatViewController.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


final class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
 
    var messages: [Message] = []
    private let cellId = "CellId"

    
    // MARK: - UI
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type something ..."
        textField.tintColor = StyleSheet.defaultTheme.mainColor
        return textField
    }()
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(StyleSheet.defaultTheme.mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(addMessage), for: .touchUpInside)
        return btn
    }()
    private lazy var logoutBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        return btn
    }()
    private var bottomConstraint: NSLayoutConstraint?
    
    
    // MARK: - Lifecycle + Layout Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "CPSC 599 Group Chat"
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = messageInputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true
        setupTextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: .UIKeyboardWillHide, object: nil)
        collectionView?.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 60, right: 0)
        navigationItem.rightBarButtonItem = logoutBtn
    }
    
    private func fetchMessages() {
        Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            // parse the messages
            let values = snapshot.value as! [String: Any]
            if let message = Message(dict: values) {
                self.appendMessage(message)
            }
        }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            // no current user, show the login screen
            perform(#selector(showLoginScreen), with: nil, afterDelay: 0.0)
        } else {
            fetchMessages()
        }
        scrollToTheEnd()
    }
    
    @objc func showLoginScreen() {
        let vc = LoginViewController()
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true, completion: nil)
    }
    
    private func setupTextField() {
        let topView = UIView()
        topView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendBtn)
        messageInputContainerView.addSubview(topView)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendBtn)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendBtn)
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topView)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topView)
    }
   

    // MARK: CollectionView Datasource and Delegates
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        let estimatedCGSize = getSGSize(for: message)
        
        if message.from == Auth.auth().currentUser?.email {
            //outgoing messages
            
            cell.textViewFrame = CGRect(x: view.frame.width - estimatedCGSize.width - 16 - 16 - 8, y: 0, width: estimatedCGSize.width + 16, height: estimatedCGSize.height + 20)
            cell.textBubbleViewFrame = CGRect(x: view.frame.width - estimatedCGSize.width - 16 - 8 - 16 - 10, y: -4, width: estimatedCGSize.width + 16 + 8 + 16, height: estimatedCGSize.height + 20 + 6)
            cell.isSender = true
            
        } else {
            // incoming messages
            cell.textViewFrame = CGRect(x: 48 + 8, y: 0, width: estimatedCGSize.width + 16, height: estimatedCGSize.height + 20)
            cell.textBubbleViewFrame = CGRect(x: 48 - 10, y: -4, width: estimatedCGSize.width + 16 + 8 + 16, height: estimatedCGSize.height + 20 + 6)
            cell.isSender = false
        }
        return cell
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedCGSize = getSGSize(for: messages[indexPath.row])
        return CGSize(width: view.frame.width, height: estimatedCGSize
            .height + 20 + 20)
    }
  
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private func getSGSize(for message: Message) -> CGRect {
        let messageBody = message.body
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: messageBody).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
    }
    
    // MARK: - Event Handlers
    
    @objc func handleKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let kbFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            self.bottomConstraint?.constant = isKeyboardShowing ? -kbFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: { completed in
                self.scrollToTheEnd()
            })
        }
    }
    
    @objc func addMessage() {
        guard let text = inputTextField.text else { return }
        guard text.count > 0 else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let message = Message(from: currentUser.email!, body: text, date: Date())
        
        // FIREBAE CODE
        
        Database.database().reference().child("messages")
            .childByAutoId()
            .setValue(message.json)
        
        //clear the textField
        inputTextField.text = ""
    }
    
    @objc func logout() {
        // FIREBASE CODE
        do {
            try Auth.auth().signOut()
            showLoginScreen()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    private func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func appendMessage(_ message: Message) {
        messages.append(message)
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.insertItems(at: [indexPath])
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    private func scrollToTheEnd() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
}



//
//  SignUpViewController.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-31.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

final class SignUpViewController: UIViewController {
    
    
    // MARK: - UI
    
    private lazy var _usernameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = #imageLiteral(resourceName: "username.png")
        textField.placeholder = "username"
        textField.color = StyleSheet.defaultTheme.mainColor
        textField.leftPadding = 16
        textField.tintColor = StyleSheet.defaultTheme.secondaryColor
        textField.backgroundColor = StyleSheet.defaultTheme.outGoingMessageColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }()
    private lazy var _emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = #imageLiteral(resourceName: "email")
        textField.placeholder = "email"
        textField.color = StyleSheet.defaultTheme.mainColor
        textField.leftPadding = 16
        textField.tintColor = StyleSheet.defaultTheme.secondaryColor
        textField.backgroundColor = StyleSheet.defaultTheme.outGoingMessageColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }()
    private lazy var _passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.color = StyleSheet.defaultTheme.mainColor
        textField.leftPadding = 16
        textField.isSecureTextEntry = true
        textField.leftImage = #imageLiteral(resourceName: "password")
        textField.tintColor = StyleSheet.defaultTheme.secondaryColor
        textField.backgroundColor = StyleSheet.defaultTheme.outGoingMessageColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }()
    private lazy var _signupBtn: RoundedButton = {
        let btn = RoundedButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Signup", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.backgroundColor = StyleSheet.defaultTheme.mainColor
        btn.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return btn
    }()
    private lazy var _stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self._usernameTextField, self._emailTextField, self._passwordTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    // MARK: - Lifecycle and layout methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To dismiss keyboard upon clicking away
        let tabRec = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tabRec)
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor

        setupUI()
    }
    
    private func setupUI() {
        view.addSubviews([_stackView, _signupBtn])
        
        NSLayoutConstraint.activate([
            _stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            _stackView.widthAnchor.constraint(equalToConstant: 350),
            _stackView.heightAnchor.constraint(equalToConstant: 250),
            
            _signupBtn.leftAnchor.constraint(equalTo: _stackView.leftAnchor),
            _signupBtn.rightAnchor.constraint(equalTo: _stackView.rightAnchor),
            _signupBtn.topAnchor.constraint(equalTo: _stackView.bottomAnchor, constant: 64),
            _signupBtn.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    
    // MARK: - Event Handler methods
    
    @objc func signup() {
        
        guard let username = _usernameTextField.text else {
            _usernameTextField.shake()
            return
        }
        guard let email = _emailTextField.text else {
            _emailTextField.shake()
            return
        }
        guard EmailValidator.isValid(email: email) else {
            _emailTextField.shake()
            return
        }
        guard let password = _passwordTextField.text  else {
            _passwordTextField.shake()
            return
        }
        guard password.count > 6 else {
            _passwordTextField.shake()
            return
        }
        
        // FIREBAE CODE
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            
            if error != nil {
                print(error ?? "")
                // show the user the error message
                self.showAlert(error!)
                return
            }
            guard let user = user else { return }

            // successfully authenticaed user, save the user to the database
            
            let ref = Database.database().reference().child("users").child(user.uid)
            let values = ["username": username, "email": email]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    self.showAlert(err!)
                    return
                }
                // successfully saved to the databse
                print("Saved user successfully to the databse")
                self.dismiss(animated: true, completion: nil)
                
                user.createProfileChangeRequest().displayName = username
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChanges()
               
            })
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
 
}

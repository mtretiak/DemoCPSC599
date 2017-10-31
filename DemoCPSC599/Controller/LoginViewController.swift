//
//  LoginViewController.swift
//  DemoCPSC599
//
//  Created by Nabil Muthanna on 2017-10-30.
//  Copyright © 2017 Victoria Lappas. All rights reserved.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    
    // MARK: - UI
    
    private lazy var _emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = #imageLiteral(resourceName: "email")
        textField.placeholder = "email"
        textField.color = StyleSheet.defaultTheme.mainColor
        textField.leftPadding = 16
        textField.backgroundColor = StyleSheet.defaultTheme.outGoingMessageColor
        textField.tintColor = StyleSheet.defaultTheme.secondaryColor
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
        textField.backgroundColor = StyleSheet.defaultTheme.outGoingMessageColor
        textField.tintColor = StyleSheet.defaultTheme.secondaryColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }()
    private lazy var _loginBtn: RoundedButton = {
        let btn = RoundedButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.backgroundColor = StyleSheet.defaultTheme.mainColor
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    private lazy var _signupBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(StyleSheet.defaultTheme.mainColor, for: .normal)
        btn.addTarget(self, action: #selector(openSignUpPage), for: .touchUpInside)
        return btn
    }()
    private lazy var _stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self._emailTextField, self._passwordTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    // MARK: - Lifecycel + layout methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To dismiss keyboard upon clicking away
        let tab = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tab)
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor

        setupUI()
    }
    
    private func setupUI() {
        view.addSubviews([_stackView, _loginBtn, _signupBtn])
        
        NSLayoutConstraint.activate([
            _stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            _stackView.widthAnchor.constraint(equalToConstant: 350),
            _stackView.heightAnchor.constraint(equalToConstant: 150),
            
            _loginBtn.leftAnchor.constraint(equalTo: _stackView.leftAnchor),
            _loginBtn.rightAnchor.constraint(equalTo: _stackView.rightAnchor),
            _loginBtn.topAnchor.constraint(equalTo: _stackView.bottomAnchor, constant: 64),
            _loginBtn.heightAnchor.constraint(equalToConstant: 70),
            
            _signupBtn.leftAnchor.constraint(equalTo: _stackView.leftAnchor),
            _signupBtn.rightAnchor.constraint(equalTo: _stackView.rightAnchor),
            _signupBtn.topAnchor.constraint(equalTo: _loginBtn.bottomAnchor, constant: 12),
            _signupBtn.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    //MARK: -  Event Handlers
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func login() {
        
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
        
        // FIREBASE CODE
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error: Error?) in
            
            if error != nil {
                // error loging in, notify user
                print(error!)
                self.showAlert(error!)
                return
            }
            
            guard let _ = user else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func openSignUpPage() {
        let vc = SignUpViewController()
        show(vc, sender: nil)
    }
   
}

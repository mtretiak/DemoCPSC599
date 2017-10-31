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
    
    
    private lazy var _emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = #imageLiteral(resourceName: "email")
        textField.placeholder = "email"
        textField.color = StyleSheet.defaultTheme.mainColor
        textField.leftPadding = 16
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
        textField.backgroundColor = StyleSheet.defaultTheme.outGoingMessageColor
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(_stackView)
        view.addSubview(_loginBtn)
        view.addSubview(_signupBtn)
        
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
        
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tab)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func login() {
        
        guard let email = _emailTextField.text,
            let password = _passwordTextField.text else { return }
        guard password.count > 6 && isValidEmail(testStr: email) else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error: Error?) in
            
            if error != nil {
                // error loging in, notify user
                print(error ?? "")
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
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

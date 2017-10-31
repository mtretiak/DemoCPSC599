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
        
        view.addSubview(_stackView)
        view.addSubview(_signupBtn)
        
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
        
        view.backgroundColor = StyleSheet.defaultTheme.contentBackgroundColor
        
        let tabRec = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tabRec)
    }
    
    
    // MARK: - Event Handler methods
    
    @objc func signup() {
        
        // u need to enable it on the firebase console
        
        // make sure they exist and they are not empty
        
        guard let username = _usernameTextField.text,
            let email = _emailTextField.text,
            let password = _passwordTextField.text else { return }
        
        guard username.count > 0 && password.count > 6 && isValidEmail(testStr: email) else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            
            if error != nil {
                print(error ?? "")
                // show the user the error message
                return
            }
            guard let user = user else { return }

            // successfully authenticaed user, save the user to the database
            
            let ref = Database.database().reference().child("users").child(user.uid)
            let values = ["username": username, "email": email]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err ?? "")
                    return
                }
                // successfully saved to the databse
                print("Saved user successfully to the databse")
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
}

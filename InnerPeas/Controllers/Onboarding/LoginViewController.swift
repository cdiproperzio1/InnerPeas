//
//  LoginViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/5/23.
//

import UIKit
import Firebase

@available(iOS 15.0, *)
class LoginViewController: UIViewController, UITextFieldDelegate {

    private let headerView = LoginHeaderView()
    //subviews
    private let emailField: TextField = {
        let field = TextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = TextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        return field
        
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = .systemYellow
        //button.setTitleColor(.link, for: .normal)
        button.setTitle("Create Account", for: .normal)
        return button
    }()
    
    //what is laoded onto the page
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        view.backgroundColor = .systemBackground
        //logo is going to go here or whatever we decide
        headerView.backgroundColor = .systemGray
        //subviews added to page
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        emailField.delegate = self
        passwordField.delegate = self
        
        addButtonActions()
        
    }
    //the location on each frame/subview loaded onto the page
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: (view.height - view.safeAreaInsets.top)/3)
        
        emailField.frame = CGRect(x: 25,
                                  y: (view.frame.height - 50) / 2 ,
                                  width: view.width-50,
                                  height: 50)
        passwordField.frame = CGRect(x: 25,
                                     y: emailField.bottom + 10 ,
                                     width: view.width-50,
                                     height: 50)
        loginButton.frame = CGRect(x: 35,
                                   y: passwordField.bottom + 30 ,
                                   width: view.width-70,
                                   height: 50)
        createAccountButton.frame = CGRect(x: 35,
                                           y: loginButton.bottom + 50 ,
                                           width: view.width-70,
                                           height: 50)
        
    }
    
    private func addButtonActions(){
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        createAccountButton.addTarget(self, action:  #selector(createAccountClicked), for: .touchUpInside)
    }
    

    
    @objc private func loginClicked(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty else {
            return
        }
        
        
    }
    @objc private func createAccountClicked(){
        let vc = createAccountViewController()
        //vc.completion = {
            
        //}
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
        }
        return true
    }
    

}

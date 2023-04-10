//
//  LoginViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/5/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {return}

        AuthManager.shared.signIn(
            email: email,
            password: password) {[weak self]result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                        print("User logged in successfully.")
                            
                    case .failure(let error):
                        print(error)
                    }
                }
            }


            
        }
    
}

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
        

    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
                let password = passwordTextField.text,
                !email.isEmpty,
                !password.isEmpty else {return}

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }

            guard let user = authResult?.user else {
                print("No user found.")
                return
            }

            let vc = TabBarViewController()
            vc.currentUser = user
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true) {
            print("User logged in successfully.")
            }
        }
    }
}

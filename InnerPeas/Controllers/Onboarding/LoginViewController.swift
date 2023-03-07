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
        let vc = TabBarViewController()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {firebaseResult, error in
            if let _ = error {
                print("error")
            }
            else{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

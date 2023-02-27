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
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) {firebaseResult, error in
            if let _ = error {
                print("error")
            }
            else{
                //go to home
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
        }
        
    }


}

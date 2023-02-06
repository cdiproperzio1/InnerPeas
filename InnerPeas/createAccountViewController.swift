//
//  createAccountViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/5/23.
//

import UIKit
import Firebase

class createAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var uNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        guard let email =  emailTextField.text else {return}
        guard let fname =  fnameTextField.text else {return}
        guard let lname =  lNameTextField.text else {return}
        guard let uname =  uNameTextField.text else {return}
        guard let password =  passwordTextField.text else {return}
        guard let confirmpassword = confirmPasswordTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: confirmpassword) { firebaseResult, error in
            if let e = error {
                print("error")
            }
            else
            {
                //Go to home screen
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

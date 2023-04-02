//
//  createAccountViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/5/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class createAccountViewController: UIViewController {
    
    private let database=Database.database().reference()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        guard let email =  emailTextField.text else {return}
        guard let fname =  fnameTextField.text else {return}
        guard let lname =  lNameTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        guard let password =  passwordTextField.text else {return}
        guard let confirmpassword = confirmPasswordTextField.text else {return}
        
        let emailRef = Database.database().reference().child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email)
        
        emailRef.observeSingleEvent(of: .value) { snapshot in
            //if email is already in database
            if snapshot.exists() {
                let alert = UIAlertController(title: "Error", message: "Account already created try and sign in using your email.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else{
                print("going to check if passwords are equal")
                if password == confirmpassword
                {
                    if password.passwordValidator()
                    {
                        guard let customizeAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "customizeAccount") as? CustomizeAccountViewController else {
                            return
                        }
                        
                        customizeAccountVC.email = email
                        customizeAccountVC.firstName = fname
                        customizeAccountVC.lastName = lname
                        customizeAccountVC.username = username
                        customizeAccountVC.password = password
                        
                        self.navigationController?.pushViewController(customizeAccountVC, animated: true)
                    }
                    //password not secure error
                    else{
                        let alert = UIAlertController(title: "Error", message: "Password must be at least 8 characters long, contain one uppercase letter, one lowercase letter, one digit, and one special character.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    //passwords dont match error
                }else{
                    let alert =  UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
}

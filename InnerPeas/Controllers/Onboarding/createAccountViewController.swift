//
//  createAccountViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/5/23.
//

import UIKit
import Firebase
import FirebaseDatabase


class createAccountViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let database = Database.database().reference()
 
//SUBVIEWS
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .purple
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    private let fNameField: TextField = {
        let field = TextField()
        field.placeholder = "First Name"
        field.keyboardType = .default
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .sentences
        return field
    }()
    
    
    private let lNameField: TextField = {
        let field = TextField()
        field.placeholder = "Last Name"
        field.keyboardType = .default
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .sentences
        return field
    }()
    
    
    private let emailField: TextField = {
        let field = TextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = TextField()
        field.placeholder = "Create Password"
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
        
    }()
    
    private let confirmPasswordField: UITextField = {
        let field = TextField()
        field.placeholder = "Confirm Password"
        field.isSecureTextEntry = true
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
        
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    public var completion: (() -> Void)?
        
    
    
    //what is laoded onto the page
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        //logo is going to go here or whatever we decide
        //subviews added to page
        view.addSubview(profilePictureImageView)
        view.addSubview(fNameField)
        view.addSubview(lNameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(createAccountButton)
        emailField.delegate = self
        passwordField.delegate = self
        addButtonActions()
        addImage()
        
    }
    //the location on each frame/subview loaded onto the page
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 90
        
        
        profilePictureImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 15, width: imageSize, height: imageSize)

        fNameField.frame = CGRect(x: 25, y: profilePictureImageView.bottom + 40, width: view.width-50, height: 50)
        lNameField.frame = CGRect(x: 25, y: fNameField.bottom + 10, width: view.width-50, height: 50)
        emailField.frame = CGRect(x: 25, y: lNameField.bottom + 10  , width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom + 10 , width: view.width-50, height: 50)
        confirmPasswordField.frame = CGRect(x: 25, y: passwordField.bottom + 10 , width: view.width-50, height: 50)
        createAccountButton.frame = CGRect(x: 35, y: confirmPasswordField.bottom + 30 , width: view.width-70, height: 50)
        
        
    }
    
    private func addImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tap)
    }
    
    private func addButtonActions(){
        createAccountButton.addTarget(self, action:  #selector(createAccountClicked), for: .touchUpInside)
    }
    
// ACTIONS
    
    @objc func didTapImage(){
        let sheet = UIAlertController(title: "Profile Picture", message: "Set a profile picture", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler:{ [weak self] _
            in
            
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.delegate = self
                self?.present(picker, animated: true)
            }
            
        } ))
        
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler:{ [weak self] _
            in
            
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self?.present(picker, animated: true)
        } ))

        
        present(sheet, animated: true)
    }
    
    @objc private func createAccountClicked()
    {
        fNameField.resignFirstResponder()
        lNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
        
        guard let fName = fNameField.text, !fName.isEmpty else {return}
        guard let lName = lNameField.text, !lName.isEmpty else {return}
        guard let email = emailField.text, !email.isEmpty else {return}
        guard let password = passwordField.text, !password.isEmpty else {return}
        guard let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {return}

        
        //Password veriifcation - seems long may check
        if password == confirmPassword
        {
            if password.passwordValidator(){
                Auth.auth().createUser(withEmail: email, password: confirmPassword)
                { [weak self] firebaseResult, error in
                    guard let self = self else {return}
                    if let _ = error {
                        let alert = UIAlertController(title: "Error", message: "Account already created try and sign in using your email.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        //Add user to database
                        let newUser: [String: Any] = [
                            "fname" : fName,
                            "lname" : lName
                        ]
                        let UID = String((Auth.auth().currentUser?.uid)!)
                        self.database.child("Users").child(UID).setValue(newUser)
                    }

                }
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Password must be at least 8 characters long, contain one uppercase letter, one lowercase letter, one digit, and one special character.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            present(alert, animated: true, completion: nil)
            }

        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Passwords dont match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //Transition to home feed once account is created
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == lNameField{
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
            createAccountClicked()
        }
        return true
    }

//IMAGE PICKER
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profilePictureImageView.image = image
    }

}

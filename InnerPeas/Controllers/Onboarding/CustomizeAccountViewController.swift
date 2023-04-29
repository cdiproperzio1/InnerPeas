//
//  CustomizeAccountViewController.swift
//  InnerPeas
//
//  Created by Cat DiProperzio on 2/13/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CustomizeAccountViewController: UIViewController, UITextViewDelegate, ImagePickerDelegate{
    
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        //let uid = String((Auth.auth().currentUser?.uid)!)
//        guard let imageData = image.pngData() else {
//            return
//        }
//        storage.child("image/\(uid).png").putData(imageData) { error in
//            guard error != nil else {
//                print("failed to upload")
//                return
//            }

            
        self.profileImage.image = image
    }
    
    
    private let storage = Storage.storage().reference()
    private let database=Database.database().reference()
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    var imagePicker: ImagePicker!
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
        profileImage.layer.cornerRadius = 120 / 2
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        textView.text = "What food do you like to make? (150 Characters)"
        textView.textColor = UIColor.lightGray
        textView.delegate=self
        
        
    }

    
    public var completion: (() -> Void)?
    
    func textViewDidBeginEditing(_ textView : UITextView ) {
        if self.textView.textColor == UIColor.lightGray {
            self.textView.text = nil
//            self.textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text.isEmpty {
            self.textView.text = "What food do you like to make? (150 Characters)"
//            self.textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func `continue`(_ sender: Any) {
        //let UID = String((Auth.auth().currentUser?.uid)!)
        if(self.textView.text == "What food do you like to make? (150 Characters)"){
            self.textView.text=" "
        }
        let imageData = profileImage.image?.pngData()
        
        AuthManager.shared.signUp(
            email: email!,
            username: username!,
            password: password!,
            profilePicture: imageData,
            firstName: firstName!,
            lastName: lastName!,
            location: location.text!,
            textView: textView.text!
        ){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserDefaults.standard.setValue(user.firstName, forKey: "first_name")
                    UserDefaults.standard.setValue(user.email, forKey: "last_name")
                    UserDefaults.standard.setValue(user.username, forKey: "username")
                    UserDefaults.standard.setValue(user.username, forKey: "bio")
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    UserDefaults.standard.setValue(user.location, forKey: "location")
                    
                    self?.storage.child("images/\(user.username).png").downloadURL(completion: {url, error in
                            guard let url = url, error == nil else {
                                return
                            }
                            let urlString = url.absoluteString
                        })
                    

                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                    self?.completion?()
                case .failure(let error):
                    print(error)
                }
            }
            
        }
            
        
    }
    
}
    
//CODE TO REUSE
//let UID = String((Auth.auth().currentUser?.uid)!)
//if(self.textView.text == "What food do you like to make? (150 Characters)"){
//    self.textView.text=" "
//}
//guard let imageData = profileImage.image?.pngData() else {
//    return
//}
//
//storage.child("image/\(UID).png").putData(imageData) { error in
//    guard error != nil else {
//        print("failed to upload")
//        return
//    }
//        self.storage.child("images/file.png").downloadURL(completion: {url, error in
//            guard let url = url, error == nil else {
//                return
//            }
//            let urlString = url.absoluteString
//        })
//    }
//self.database.child("Users").child(UID).child("bio").setValue(self.textView.text!)
//self.database.child("Users").child(UID).child("location").setValue(self.location.text!)
//let vc = TabBarViewController()
//vc.modalPresentationStyle = .fullScreen
//self.present(vc, animated: true)
//}





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
        self.profileImage.image = image
    }
    
    @IBOutlet weak var location: UITextField!
    private let storage = Storage.storage().reference()
    private let database=Database.database().reference()
    @IBOutlet weak var profileImage: UIImageView!
    var imagePicker: ImagePicker!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        textView.text = "What food do you like to make? (150 Characters)"
        textView.textColor = UIColor.lightGray
        textView.delegate=self
        
    }
    
    func textViewDidBeginEditing(_ textView : UITextView ) {
        if self.textView.textColor == UIColor.lightGray {
            self.textView.text = nil
            self.textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textView.text.isEmpty {
            self.textView.text = "What food do you like to make? (150 Characters)"
            self.textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
  
    @IBAction func `continue`(_ sender: Any) {
        let UID = String((Auth.auth().currentUser?.uid)!)
        if(self.textView.text == "What food do you like to make? (150 Characters)"){
            self.textView.text=" "
        }
        guard let imageData = profileImage.image?.pngData() else {
            return
        }
       
        storage.child("image/\(UID).png").putData(imageData) { error in
            guard error != nil else {
                print("failed to upload")
                return
            }
                self.storage.child("images/file.png").downloadURL(completion: {url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let urlString = url.absoluteString
                })
            }
        self.database.child("Users").child(UID).child("bio").setValue(self.textView.text!)
        self.database.child("Users").child(UID).child("location").setValue(self.location.text!)
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    }




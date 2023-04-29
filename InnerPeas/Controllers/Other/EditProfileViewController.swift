//
//  EditProfileViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/27/23.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    public var completion: (() -> Void)?
    
    let fnameField: TextField = {
        let field = TextField()
        field.placeholder = "First Name..."
        return field
        
    }()
    
    let lnameField: TextField = {
        let field = TextField()
        field.placeholder = "Last Name..."
        return field
        
    }()
    
    let locationField: TextField = {
        let field = TextField()
        field.placeholder = "Location..."
        return field
        
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.font = .systemFont(ofSize: 14)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit profile"
        view.backgroundColor = .systemBackground
        view.addSubview(fnameField)
        view.addSubview(lnameField)
        view.addSubview(locationField)
        view.addSubview(bioTextView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave))
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        DatabaseManager.shared.getUserInfo(username: username) { [weak self] info in
            DispatchQueue.main.async {
                if let info = info {
                    self?.fnameField.text = info.firstName
                    self?.lnameField.text = info.lastName
                    self?.locationField.text = info.location
                    self?.bioTextView.text = info.bio
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fnameField.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+10,
            width: view.width-40,
            height: 50)
        
        lnameField.frame = CGRect(
            x: 20,
            y: fnameField.bottom+10,
            width: view.width-40,
            height: 50)
        
        locationField.frame = CGRect(
            x: 20,
            y: lnameField.bottom+10,
            width: view.width-40,
            height: 50)
        
        bioTextView.frame = CGRect(
            x: 20,
            y: locationField.bottom+10,
            width: view.width-40,
            height: 300)
    }
    
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapSave(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        guard let email = UserDefaults.standard.string(forKey: "email") else {return}
        let fname = fnameField.text ?? ""
        let lname = lnameField.text ?? ""
        let location = locationField.text ?? ""
        let bio = bioTextView.text ?? ""
        var newInfo = User(username: username, email: email, firstName: "", lastName: "", location: "", bio: "")
        
        DatabaseManager.shared.getUserInfo(username: username) { [weak self] info in
            DispatchQueue.main.async {
                if let info = info {
                     newInfo = User(username: info.username, email: info.email ,firstName: fname, lastName: lname, location: location, bio: bio)
                }
                DatabaseManager.shared.updateUserInfo(userInfo: newInfo) { [weak self] success in
                    DispatchQueue.main.async {
                        if success {
                            self?.completion?()
                            self?.didTapClose()
                        }
                    }
                }
            }

        }
    }
}

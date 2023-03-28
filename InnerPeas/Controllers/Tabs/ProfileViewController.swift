//
//  ProfileViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    private let user: User
    private var isCurrentUser: Bool
    private let usersRef = Database.database().reference().child("users")

    
    
    
    init(user: User){
        self.user = user
        self.isCurrentUser = (user.username == Auth.auth().currentUser?.uid)
        super.init(nibName: nil, bundle: nil)
        
        let uid = user.username
        usersRef.child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let userData = snapshot.value as? [String: Any],
                  let username = userData["username"] as? String else {
                print("Error: Could not retrieve user data")
                return
            }
            self.title = username
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configure() {
        if isCurrentUser{
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
    }
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }

}

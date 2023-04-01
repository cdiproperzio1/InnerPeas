//
//  ProfileViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    private var user: User
    private var isCurrentUser: Bool
    private let usersRef = Database.database().reference().child("Users")

    
    init(user: User) {
        self.user = user
        self.isCurrentUser = (user.uid == Auth.auth().currentUser?.uid)
        super.init(nibName: nil, bundle: nil)

        usersRef.child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error: Could not retrieve user data")
                return
            }
            
            self.user.username = userData["username"] as? String
            
            self.title = user.username
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

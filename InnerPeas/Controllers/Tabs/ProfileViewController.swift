//
//  ProfileViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    let User = Auth.auth().currentUser
    
    private let user: User
    
    private var isCurrentUser: Bool{
        return (user.email != nil)
    }
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.email
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

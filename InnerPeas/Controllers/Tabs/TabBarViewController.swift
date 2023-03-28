//
//  TabBarViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import UIKit
import Firebase
import FirebaseDatabase

class TabBarViewController: UITabBarController {
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        if let currentUser = Auth.auth().currentUser {
            //create the views
            let home = HomeViewController()
            let addPost =  AddPostViewController()
            let search = SearchViewController()
            let profile = ProfileViewController(user: currentUser)
            
            //turn views into navigation
            let nav1 = UINavigationController(rootViewController: home)
            let nav2 = UINavigationController(rootViewController: addPost)
            let nav3 = UINavigationController(rootViewController: search)
            let nav4 = UINavigationController(rootViewController: profile)
            
            nav1.navigationBar.tintColor = .label
            nav2.navigationBar.tintColor = .label
            nav3.navigationBar.tintColor = .label
            nav4.navigationBar.tintColor = .label
            
            //create tabs
            nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
            nav2.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "plus.app"), tag: 1)
            nav3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
            nav4.tabBarItem = UITabBarItem(title: currentUser.email, image: UIImage(systemName: "person.circle"), tag: 1)
            
            //set controllers
            self.setViewControllers([nav1, nav2, nav3, nav4], animated: false)
        }else{
            print("User not signed in")
        }
        
    }
}

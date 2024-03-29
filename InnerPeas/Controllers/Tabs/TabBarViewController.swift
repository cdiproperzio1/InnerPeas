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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
               let email = UserDefaults.standard.string(forKey: "email") else{
             return
         }
         let currentUser = User(
             username: username,
             email: email
         )
        
         //create the views
         let home = HomeViewController()
         let addPost =  AddPostViewController()
         let search = SearchViewController()
         let notification = NotificationViewController()
         let profile = ProfileViewController(user: currentUser)
        
         //turn views into navigation
         let nav1 = UINavigationController(rootViewController: home)
         let nav2 = UINavigationController(rootViewController: addPost)
         let nav3 = UINavigationController(rootViewController: search)
         let nav4 = UINavigationController(rootViewController: notification)
         let nav5 = UINavigationController(rootViewController: profile)
        
         nav1.navigationBar.tintColor = .label
         nav2.navigationBar.tintColor = .label
         nav3.navigationBar.tintColor = .label
         nav4.navigationBar.tintColor = .label
         nav5.navigationBar.tintColor = .label

        
         //create tabs
         nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
         nav2.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "plus.app"), tag: 1)
         nav3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
         nav4.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(systemName: "bell.fill"), tag: 1)
         nav5.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
         //set controllers
         self.setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: false)
        }
        

}


//TEMP CODE


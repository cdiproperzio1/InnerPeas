//
//  AppDelegate.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/1/23.
//

import UIKit
import FirebaseCore
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateString = dateFormatter.string(from: Date())
//        let id = NotificationManager.createID()
//        let model = PeasNotification(
//            identifier: id,
//            notificationType: 1,
//            profilePictureUrl: "https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634__480.png",
//            username: "jerry",
//            isFollowing: false,
//            postID: nil,
//            postURL: nil,
//            dateString: dateString
//        )
//        NotificationManager.shared.create(notification: model, for: "mj")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


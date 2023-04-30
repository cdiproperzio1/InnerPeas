//
//  DatabaseManager.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 3/22/23.
//

import Foundation
import Firebase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Database.database().reference()
    
    //CREATE USER FUNC
    public func createUser(
        newUser: User,
        firstName: String?,
        lastName: String?,
        location: String?,
        bio: String?,
        completion: @escaping (Bool) -> Void) {
            let reference = database.child("Users/\(newUser.username)")
            guard let data = newUser.asDictionary() else {
                completion(false)
                return
            }
            var userData = data
            if let firstName = firstName {
                userData["first_name"] = firstName
            }
            if let lastName = lastName {
                userData["last_name"] = lastName
            }
            if let location = location {
                userData["location"] = location
            }
            if let bio = bio {
                userData["bio"] = bio
            }
            reference.setValue(data) { error, _ in
                completion(error == nil)
            }
        }
    //FIND USER FOR PROFILE FUNC
    public func findUser(with email: String, completion: @escaping (User?) -> Void){
        let ref = database.child("Users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let usersDict = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let users = usersDict.compactMap { (key, value) -> User? in
                guard let userDict = value as? [String: Any] else {
                    return nil
                }
                var user = User(with: userDict)
                user?.username = key
                return user
            }
            let user = users.first(where: {$0.email == email})
            completion(user)
        }
    }
    
    public func findUser(username: String, completion: @escaping (User?) -> Void){
        let ref = database.child("Users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let usersDict = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let users = usersDict.compactMap { (key, value) -> User? in
                guard let userDict = value as? [String: Any] else {
                    return nil
                }
                var user = User(with: userDict)
                user?.username = key
                return user
            }
            let user = users.first(where: {$0.username == username})
            completion(user)
        }
    }
    
    //RETRIEVE POST FOR FEED FUNC
    public func posts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        let ref = Database.database().reference().child("Users").child(username).child("Posts")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: AnyObject] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is not available"])))
                return
            }
            
            var posts = [Post]()
            
            for (key, data) in value {
                if let data = data as? [String: Any] {
                    var postData = data
                    postData["id"] = key
                    if let post = Post(with: postData) {
                        posts.append(post)
                    }
                }
            }
            
            
            completion(.success(posts))
        }) { error in
            completion(.failure(error))
        }
    }
    
    //SEARCH USER FUNC
    public func searchUsers(
        with usernamePrefix: String,
        completion: @escaping ([User]) -> Void){
            
            let ref = database.child("Users")
            
            ref.observeSingleEvent(of: .value) { snapshot in
                guard let usersDict = snapshot.value as? [String: Any] else {
                    completion([])
                    return
                }
                let users = usersDict.compactMap { (key, value) -> User? in
                    guard let userDict = value as? [String: Any] else {
                        return nil
                    }
                    var user = User(with: userDict)
                    user?.username = key
                    return user
                }
                let subset = users.filter({
                    $0.username.lowercased().hasPrefix(usernamePrefix.lowercased())
                })
                
                completion(subset)
            }
        }
    
    //FUNC FOR SEARCH FEED
    public func explorePosts(completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("Users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let usersData = snapshot.value as? [String: [String: AnyObject]] else {
                completion([])
                return
            }
            
            let users = usersData.compactMap { (_, userData) -> User? in
                return User(with: userData)
            }
            
            let group = DispatchGroup()
            var aggregatePosts = [Post]()
            
            users.forEach { user in
                group.enter()
                //print("\n\n\n this is user \(user)")
                let username = user.username
                let postRef = Database.database().reference().child("Users/\(username)/Posts")
                print("\n\n\n post ref \(postRef)")
                
                postRef.observeSingleEvent(of: .value) { snapshot in
                    defer {
                        group.leave()
                    }
                    
                    guard let postsData = snapshot.value as? [String: [String: AnyObject]] else {
                        return
                    }
                    //print("\n\n\n This is the post data here: \(postsData)")
                    
                    
                    let posts = postsData.compactMap { (_, postData) -> Post? in
                        //print("\n\n\n This is the post \(String(describing: Post(with: postData)))")
                        return Post(with: postData)
                    }
                    //print("\n\n\n this is the post with a s \(posts)")
                    aggregatePosts.append(contentsOf: posts)
                }
            }
            
            group.notify(queue: .main) {
                completion(aggregatePosts)
            }
        }
    }
    
    
    
    
    
    
    
    public func createPost(newPost: Post, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference().child("Users").child(username).child("Posts").child(newPost.id)
        guard let data = newPost.asDictionary() else {
            completion(false)
            return
        }
        
        ref.setValue(data) { error, _ in
            completion(error == nil)
        }
    }
    
    public func getUserCounts(
        username: String,
        completion: @escaping ((followers: Int, following: Int, recipe: Int)) -> Void) {
        
        let ref = Database.database().reference().child("Users").child(username)
        var followers = 0
        var following = 0
        var recipe = 0
        
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        // Get follower count
        ref.child("Followers").observeSingleEvent(of: .value, with: { snapshot in
            followers = Int(snapshot.childrenCount)
            group.leave()
        })
        
        // Get following count
        ref.child("Following").observeSingleEvent(of: .value, with: { snapshot in
            following = Int(snapshot.childrenCount)
            group.leave()
        })
        
        // Get recipe count
        ref.child("Posts").observeSingleEvent(of: .value, with: { snapshot in
            recipe = Int(snapshot.childrenCount)
            group.leave()
        })
        
        group.notify(queue: .global()) {
            let result = (followers: followers,
                          following: following,
                          recipe: recipe
                        )
            completion(result)
        }
    }

    public func isFollowing(
        targetUsername: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        let ref = Database.database().reference().child("Users")
                  .child(targetUsername)
                  .child("Followers")
                  .child(currentUsername)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), snapshot.value != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    

    public func getNotifications(completion: @escaping ([PeasNotification]) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion([])
            return
        }
        let ref = Database.database().reference().child("Users").child(username).child("Notifications")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let notificationsDict = snapshot.value as? [String: AnyObject] else {
                completion([])
                return
            }
            
            var notifications: [PeasNotification] = []
            for (_, value) in notificationsDict {
                if let notificationData = value as? [String: Any],
                   let notification = PeasNotification(with: notificationData) {
                    notifications.append(notification)
                }
            }
            //print("\n\n\n These are the notification being retrieved \(notifications)")
            completion(notifications)
        }
    }
    
    public func insertNotification(identifier: String, data: [String: Any], for username: String){
        let ref = Database.database().reference().child("Users").child(username).child("Notifications").child(identifier)
        
        ref.setValue(data)
        
    }
    

    public func getPost(
        with identifier: String,
        from username: String,
        completion: @escaping (Post?) -> Void)
    {
        let ref = Database.database().reference().child("Users").child(username).child("Posts").child(identifier)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            completion(Post(with: data))
        }
    }
    
    enum RelationshipState: String {
        case follow
        case unfollow
    }
    
    public func updateRelationship(
        state: RelationshipState,
        for targetUsername: String,
        completion: @escaping (Bool) -> Void)
    {
        guard let requesterUsername = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        
        let currentFollowing = Database.database().reference().child("Users").child(requesterUsername).child("Following")
        
        let targetUserFollower = Database.database().reference().child("Users").child(targetUsername).child("Followers")
        

        switch state {
        case .unfollow:
            currentFollowing.child(targetUsername).removeValue()
            targetUserFollower.child(requesterUsername).removeValue()
            completion(true)
        case .follow:
            currentFollowing.child(targetUsername).setValue(["valid":"1"])
            targetUserFollower.child(requesterUsername).setValue(["valid":"1"])
            completion(true)
            
        }
        
    }
    
    public func followers(for username: String, completion: @escaping ([String]) -> Void){
        let ref = Database.database().reference().child("Users").child(username).child("Followers")

        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists(), let value = snapshot.value as? [String: AnyObject] else {
                completion([])
                return
            }
            let usernames = Array(value.keys)
            completion(usernames)
        }) { error in
            print(error.localizedDescription)
            completion([])
        }


    }
    
    public func following(for username: String, completion: @escaping ([String]) -> Void){
        let ref = Database.database().reference().child("Users").child(username).child("Following")

        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists(), let value = snapshot.value as? [String: AnyObject] else {
                completion([])
                return
            }
            let usernames = Array(value.keys)
            completion(usernames)
        }) { error in
            print(error.localizedDescription)
            completion([])
        }


    }
    

    public func getUserInfo(username: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("Users").child(username)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any],
                  let userInfo = User(with: data) else {
                completion(nil)
                return
            }
            completion(userInfo)
        }
    }
    
    public func updateUserInfo(userInfo: User, completion: @escaping (Bool) -> Void){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        var updates: [String: Any] = [:]
        if let fname = userInfo.firstName {
            updates["firstName"] = fname
        }
        if let lname = userInfo.lastName {
            updates["lastName"] = lname
        }
        if let location = userInfo.location {
            updates["location"] = location
        }
        if let bio = userInfo.bio {
            updates["bio"] = bio
        }
        
        let ref = Database.database().reference().child("Users").child(username)
        ref.updateChildValues(updates) { error, _ in
            completion(error == nil)
        }
    }

}
                                                                           

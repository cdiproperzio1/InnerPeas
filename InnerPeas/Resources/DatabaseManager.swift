//
//  DatabaseManager.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 3/22/23.
//

import Foundation
import Firebase
import FirebaseFirestore

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
    
    //RETRIEVE POST FOR FEED FUNC
    public func posts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        let ref = Database.database().reference().child("Users").child(username).child("Post")
        
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
                 //print("\n\n\n post ref \(postRef)")

                 postRef.observeSingleEvent(of: .value) { snapshot in
                     defer {
                         group.leave()
                     }

                     guard let postsData = snapshot.value as? [String: [String: AnyObject]] else {
                         return
                     }
                     //print("\n\n\n This is the post data here: \(postsData)")
                     

                     let posts = postsData.compactMap { (_, postData) -> Post? in
                         print("\n\n\n This is the post \(String(describing: Post(with: postData)))")
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

}

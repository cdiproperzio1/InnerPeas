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
    
    public func posts(
        for username: String,
        completion: @escaping (Result<[Post], Error>) -> Void){
            
        }
    
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
    
    
    public func explorePosts(completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("Users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var aggregatePosts = [Post]()
            let group = DispatchGroup()
            
            for child in snapshot.children {
                guard let userSnapshot = child as? DataSnapshot,
                      let userValue = userSnapshot.value as? [String: Any],
                      let username = userValue["username"] as? String else {
                    continue
                }
                
                group.enter()
                let postRef = Database.database().reference().child("Users/\(username)/Post")
                
                postRef.observeSingleEvent(of: .value) { postSnapshot in
                    guard let postDict = postSnapshot.value as? [String: [String: Any]] else {
                        group.leave()
                        return
                    }
                    
                    let posts = postDict.compactMap { Post(with: $0.value) }
                    aggregatePosts.append(contentsOf: posts)
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(aggregatePosts)
            }
        }
    }
    
}

//
//  Storage.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import Foundation
import FirebaseStorage
import Firebase

final class StorageManager{
    static let shared = StorageManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(
        username: String,
        data: Data?,
        completion: @escaping (Bool) -> Void
    ){
        guard let data = data else {
            return
        }
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil) { _, error in completion(error==nil)
        }
    }
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (Bool) -> Void
    ){
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data = data else {
            return
        }
        storage.child("\(username)/posts/(id).png").putData(data, metadata: nil) { _, error in completion(error==nil)
        }
    }
    
}

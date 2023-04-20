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
    
    public func profilePictureURL(for username: String, completion: @escaping (URL?) -> Void){
        storage.child("\(username)/profile_picture.png").downloadURL{ url, _ in
            completion(url)
            
        }
    }
    public func uploadPost(
        data: Data?,
        id: String,
        imageID: String,
        completion: @escaping (URL?) -> Void
    ){
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let data = data else {
            return
        }
        let ref = storage.child("\(username)/Posts/post_\(id)/\(imageID).png")
        ref.putData(data, metadata: nil) { _, error in
            ref.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
//    public func downloadURL(for post: Post, completion: @escaping (URL?) -> Void){
//        guard let ref = post.storageReference else {
//            completion(nil)
//            return
//        }
//
//        let storageRef = Storage.storage().reference().child(ref)
//        print("\n\n\n This is the storage reference \(storageRef)")
//
//        storageRef.listAll { (result, error) in
//            if let error = error {
//                print("Error: \(error)")
//                completion(nil)
//                return
//            }
//            print("\n\n\n These are the results \(result)")
//            let firstFile = result?.items.first
//            print("This is the first file in the folder \(firstFile)")
//
//        }
//
//
//        print("finished list all")
//
//    }
    
}

//    var urls: [URL] = []
//
//    if let items = result?.items {
//        print("This is the item in each folder \(items)")
//        for item in items {
//            item.downloadURL { url, error in
//                if let url = url {
//                    urls.append(url)
//                }
//                if urls.count == items.count {
//                    if let firstURL = urls.first {
//                        print("this is image link \(firstURL)")
//                        completion(firstURL)
//                    } else {
//                        completion(nil)
//                    }
//                }
//            }
//
//        }
//
//    } else {
//        print("no items found")
//        completion(nil)
//    }
//}

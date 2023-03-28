////
////  DatabaseManager.swift
////  InnerPeas
////
////  Created by Justin Hamilton on 3/22/23.
////
//
//import Foundation
//import Firebase
//import FirebaseFirestore
//
//final class DatabaseManager {
//    static let shared = DatabaseManager()
//
//    private init() {}
//    
//    let database = Firestore.firestore()
//
//    public func createUser(newUser: User, completion: @escaping (Bool) -> Void) {
//        let reference = database.document("users/\newUser.username)")
//        guard let data = newUser.asDictionary() else {
//            completion(false)
//        }
//        reference.setData([:]) {error in
//            completion(error == nil)
//        }
//    }
//
//}

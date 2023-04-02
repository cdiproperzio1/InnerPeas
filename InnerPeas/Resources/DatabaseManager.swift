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
}

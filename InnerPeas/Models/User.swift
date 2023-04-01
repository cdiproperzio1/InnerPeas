//
//  User.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import Foundation
import FirebaseAuth
import Firebase

struct User: Codable{
    var username: String?
    let email: String
    let uid: String
    
    init(fromFirebaseUser user: FirebaseAuth.User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }
}

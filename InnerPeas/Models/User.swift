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
    let username: String
    let email: String
    
    init(fromFirebaseUser user: FirebaseAuth.User) {
        self.username = user.uid
        self.email = user.email ?? ""
    }
}

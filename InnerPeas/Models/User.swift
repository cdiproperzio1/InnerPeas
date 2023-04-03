//
//  User.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import Foundation
import FirebaseAuth
import Firebase

struct User: Codable {
    var username: String
    let email: String
    var firstName: String?
    var lastName: String?
    var location: String?
    var bio: String?
}


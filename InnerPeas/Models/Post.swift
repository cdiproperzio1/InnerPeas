//
//  Post.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import Foundation
import FirebaseStorage

struct Post: Codable {
    let id: String
    let title: String
    let directions: String
    let postURLString: String
    let postURLs: [String]
    let ingredients: [[String:String]]
    
    var storageReference: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil}
        return "\(username)/Posts/\(id)"
 
    }
    
    init(id: String, title: String, directions: String, postURLString: String, postURLs: [String] = [], ingredients: [[String:String]]) {
        self.id = id
        self.title = title
        self.directions = directions
        self.postURLString = postURLString
        self.postURLs = postURLs
        self.ingredients = ingredients
    }
}

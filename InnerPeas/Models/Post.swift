//
//  Post.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import Foundation

struct Post: Codable {
    let id: String
    //let postedDate: String
    let title: String
    
    var storageRefence: String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil}
        return "\(username)/posts/\(id).png"
    }
}

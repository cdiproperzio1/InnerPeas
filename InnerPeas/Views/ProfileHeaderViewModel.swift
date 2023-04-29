//
//  ProfileHeaderViewModel.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import Foundation

enum ProfileButtonType {
    case edit
    case follow(isFollowing: Bool)
}
struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let followingCount: Int
    let followerCount: Int
    let recipeCount: Int
    let bio: String?
    let buttonType: ProfileButtonType
    let name: String?
    let location: String?
}

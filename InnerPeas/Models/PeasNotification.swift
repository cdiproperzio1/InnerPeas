//
//  Notification.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import Foundation

struct PeasNotification: Codable {
    let identifier: String
    let notificationType: Int //1 follow, 2 comment
    let profilePictureUrl: String
    let username: String
    let isFollowing: Bool?
    let postID: String?
    let postURL: String?
    let dateString: String
}

//
//  NotificationCellViewModels.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import Foundation

struct FollowNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureURL: URL
    let isCurrentUserFollowing: Bool
    let date: String
}
struct CommentNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureURL: URL
    let postURL: URL
    let date: String
}

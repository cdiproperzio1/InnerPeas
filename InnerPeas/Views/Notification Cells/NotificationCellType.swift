//
//  NotificationCelltype.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}

//
//  NotificationManager.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import Foundation

final class NotificationManager {
    static let shared = NotificationManager()
    
    enum PeasType: Int {
        case follow = 1
        case comment = 2
    }
    
    private init(){}
    
    public func getNotifications(completion: @escaping ([PeasNotification]) -> Void)
    {
        DatabaseManager.shared.getNotifications(completion: completion)
    }
    
    static func createID() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTimeString = dateFormatter.string(from: Date())
        let num1 = Int.random(in: 0...1000)
        let num2 = Int.random(in: 0...1000)
        return "\(num1)_\(num2)_\(currentDateTimeString)"
        
    }
    
    public func create(
        notification: PeasNotification,
        for username: String)
    {
        let id = notification.identifier
        guard let dictionary = notification.asDictionary() else {
            return
        }
        DatabaseManager.shared.insertNotification(identifier: id, data: dictionary, for: username)
        
    }
}

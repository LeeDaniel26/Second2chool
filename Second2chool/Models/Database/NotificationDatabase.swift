//
//  NotificationDatabase.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/6/24.
//

import Foundation

struct NotificationDatabase: Codable {
    let status: String
    let data: NotificationData
}

struct NotificationData: Codable {
    let notificationCount: Int
    let notifications: [Notifications]
}

struct Notifications: Codable {
    let id: Int
    let from: String
    let url: String
    let content: String
    let notificationType: String
    let createdAt: String
}

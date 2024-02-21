//
//  UserDatabase.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/21/24.
//

import Foundation

struct UserDatabase: Codable {
    let status: String
    let data: UserData
}

struct UserData: Codable {
    let id: String
    let nickname: String
    let email: String
    let role: String
    let profileImageUrl: String?
}


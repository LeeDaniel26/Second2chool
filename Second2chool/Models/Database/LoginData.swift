//
//  LoginData.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/29.
//

import Foundation

struct GoogleSignInDatabase: Codable {
    let status: String
    let data: GoogleSignInData
}

struct GoogleSignInData: Codable {
    let id: String
    let nickname: String
    let email: String
    let accessToken: String
}

struct NicknameCheckDatabase: Codable {
    let status: String
    let data: Bool
}

struct LoginData: Codable {
    let status: String
    let data: Datas
}

struct Datas: Codable {
    let accessToken: String
}

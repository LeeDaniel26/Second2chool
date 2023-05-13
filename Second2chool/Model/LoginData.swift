//
//  LoginData.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/29.
//

import Foundation

struct LoginData: Codable {
    let status: String
    let data: Datas
}

struct Datas: Codable {
    let accessToken: String
}

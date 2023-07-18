//
//  FreeBoardData.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/05.
//

import Foundation

struct FreeBoardData: Codable {
    let status: String
    let data: Data
}

struct Data: Codable {
    let contents: [Contents]
    let currentPage: Int
    let totalPages: Int
    let totalElements: Int
    let numberOfElements: Int
    let size: Int
}

struct Contents: Codable {
    let id: Int
    let title: String
    let content: String
    let writerName: String
    let isAnon: Bool
    let isLiked: Bool
    let isScrapped: Bool
    let isWriter: Bool
    let commentOn: Bool
    let createdAt: String
    let updatedAt: String
    let commentCnt: Int
    let likeCnt: Int
    let scrapCnt: Int
    let photoCnt: Int
}

//
//  SinglePostDatabase.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import Foundation

struct SinglePostDatabase: Codable {
    let status: String
    let data: SinglePostData
}

struct SinglePostData: Codable {
    let id: Int
    let title: String
    let content: String
    let writerName: String
    let isAnon: Bool
    let isLiked : Bool
    let isScrapped: Bool
    let isWriter: Bool
    let commentOn: Bool
    let commentCnt: Int
    let reviewScore: Int?
    let postType: String
    let createdAt: String
    let updatedAt: String
    let commentList: [CommentList]
    let photoList: [String]    // ??? It was []..?
}

struct CommentList: Codable {
    let id: Int
    let parentId: Int?
    let ancestorId: Int?
    let likeCnt: Int
    let content: String
    let writerName: String
    let isAnon: Bool
    let isLiked: Bool
    let isWriter: Bool
    let isPostWriter: Bool
    let createdAt: String
    let updatedAt: String
    let child: [CommentList]
}

struct SinglePostPhotoDatabase: Codable {
    let status: String
    let data: String
}

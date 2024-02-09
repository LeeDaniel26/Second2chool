//
//  CommentViewModel.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import Foundation

struct CommentViewModel {
    let profilePictureURL: URL
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

//
//  PostCellType.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import Foundation

enum PostCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case postTitle(viewModel: PostTitleCollectionViewCellViewModel)
    case postBody(viewModel: PostBodyCollectionViewCellViewModel)
    case likesCount(viewModel: PostLikesCollectionViewCellViewModel)
    case comment(viewModel: CommentViewModel)
//    case commentReply(viewModel: [CommentList])
}

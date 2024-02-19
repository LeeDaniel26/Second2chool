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
    case postPhotos(viewModel: PostPhotosViewModel)
    case likesCount(viewModel: PostLikesCollectionViewCellViewModel)
    case comment(viewModel: CommentViewModel)
    case commentReply(viewModel: CommentViewModel)
}

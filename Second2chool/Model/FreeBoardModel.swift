//
//  FreeBoardModel.swift
//  Second2chool
//
//  Created by Daniel on 2023/04/05.
//

import Foundation

struct FreeBoardModel {
    let contents: [Contents]
    let totalPages: Int
    let cellCount: Int
    
    let title: String
    let content: String
    let writerName: String
    let isAnon: Bool
}

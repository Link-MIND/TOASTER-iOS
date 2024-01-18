//
//  SearchResultModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/9/24.
//

import Foundation

struct SearchResultModel {
    let detailClipList: [SearchResultDetailClipModel]
    let clipList: [SearchResultClipModel]
}

struct SearchResultDetailClipModel {
    let iD: Int
    let title: String
    let link: String
    let imageURL: String?
    let clipTitle: String?
    let isRead: Bool
}

struct SearchResultClipModel {
    let iD: Int
    let title: String
    let numberOfDetailClip: Int
}

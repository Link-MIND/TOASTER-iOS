//
//  ClipListModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/5/24.
//

import Foundation

struct ClipListModel: Codable {
    let categoryID: Int
    let categoryTitle: String
    let toastNum: Int
}

// TODO: - 테스트용 더미 데이터, 서버 연결 후 지울 것!
 var dummyClipList: [ClipListModel] = [.init(categoryID: 1, categoryTitle: "title", toastNum: 50)]
// var dummyClipList: [ClipListModel] = []

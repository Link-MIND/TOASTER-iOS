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

var dummyClipList: [ClipListModel] = [.init(categoryID: 1, categoryTitle: "제목", toastNum: 50)]

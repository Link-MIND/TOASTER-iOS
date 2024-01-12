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

var dummyClipList: [ClipListModel] = [.init(categoryID: 1, categoryTitle: "title1", toastNum: 50),
                                      .init(categoryID: 2, categoryTitle: "title2", toastNum: 50),
                                      .init(categoryID: 3, categoryTitle: "title3", toastNum: 50),
                                      .init(categoryID: 4, categoryTitle: "title4", toastNum: 50),
                                      .init(categoryID: 5, categoryTitle: "title5", toastNum: 50),
                                      .init(categoryID: 6, categoryTitle: "title6", toastNum: 50),
                                      .init(categoryID: 7, categoryTitle: "title7", toastNum: 50),
                                      .init(categoryID: 8, categoryTitle: "title8", toastNum: 50),
                                      .init(categoryID: 9, categoryTitle: "title9", toastNum: 50),
                                      .init(categoryID: 10, categoryTitle: "title10", toastNum: 50)]
// var dummyClipList: [ClipListModel] = []

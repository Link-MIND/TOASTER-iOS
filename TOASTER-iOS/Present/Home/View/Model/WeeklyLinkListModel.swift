//
//  WeeklyLinkListModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import Foundation

struct WeeklyLinkListModel: Codable {
    let allToastNum: Int
    let toastListDto: [ToastList]
}

// MARK: - ToastList

struct ToastList: Codable {
    let toastTitle: String
    let linkURL: String
    let isRead: Bool
    let toastThubnail: String
    
    
    init(toastTitle: String, linkURL: String, isRead: Bool, toastThubnail: String) {
        self.toastTitle = toastTitle
        self.linkURL = linkURL
        self.isRead = isRead
        self.toastThubnail = toastThubnail
    }
}


var dummyWeeklyLinkList: [WeeklyLinkListModel] = [
    WeeklyLinkListModel(allToastNum: 1,
                        toastListDto: [ToastList(toastTitle: "Title",
                                                 linkURL: "https://linklinklink",
                                                 isRead: true, toastThubnail: "아직 사진 url 연결 안함")]),
    WeeklyLinkListModel(allToastNum: 2,
                        toastListDto: [ToastList(toastTitle: "Title",
                                                 linkURL: "https://linklinklink",
                                                 isRead: true, toastThubnail: "아직 사진 url 연결 안함")]),
    WeeklyLinkListModel(allToastNum: 3,
                        toastListDto: [ToastList(toastTitle: "Title",
                                                 linkURL: "https://linklinklink",
                                                 isRead: true, toastThubnail: "아직 사진 url 연결 안함")]),
]

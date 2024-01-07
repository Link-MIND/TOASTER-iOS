//
//  DetailClipListModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/7/24.
//

import Foundation

struct DetailClipListModel: Codable {
    let allToastNum: Int
    let toastListDto: [ToastList]
}

// MARK: - ToastList
struct ToastList: Codable {
    let toastTitle: String
    let linkURL: String
    let isRead: Bool
    let toastThubnail: String
}

// var dummyDetailClipList: [DetailClipListModel] = []
var dummyDetailClipList: [DetailClipListModel] = [
    DetailClipListModel(allToastNum: 1, toastListDto: [ToastList(toastTitle: "dsd", linkURL: "Dasd", isRead: true, toastThubnail: "dasd")]),
    DetailClipListModel(allToastNum: 2, toastListDto: [ToastList(toastTitle: "dsd", linkURL: "Dasd", isRead: false, toastThubnail: "dasd")])
]

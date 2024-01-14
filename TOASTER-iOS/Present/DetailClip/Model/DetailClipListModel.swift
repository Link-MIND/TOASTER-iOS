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
    let toastId: Float
    let toastTitle: String
    let linkURL: String
    let isRead: Bool
    let categoryTitle: String
    let toastThubnail: String
}

// var dummyDetailClipList: [DetailClipListModel] = []
var dummyDetailClipList: [DetailClipListModel] = [
    DetailClipListModel(allToastNum: 1, toastListDto: [ToastList(toastId: 1, toastTitle: "Title", linkURL: "https://example.com", isRead: true, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 2, toastListDto: [ToastList(toastId: 1, toastTitle: "코딩하는 체대생", linkURL: "https://mini-min-dev.tistory.com/dsadasdasdasdasdsadasdasd", isRead: false, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 1, toastListDto: [ToastList(toastId: 1, toastTitle: "Title", linkURL: "https://linklinklink", isRead: true, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 2, toastListDto: [ToastList(toastId: 1, toastTitle: "코딩하는 체대생", linkURL: "https://mini-min-dev.tistory.com/", isRead: false, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 1, toastListDto: [ToastList(toastId: 1, toastTitle: "Title", linkURL: "https://linklinklink", isRead: true, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 2, toastListDto: [ToastList(toastId: 1, toastTitle: "코딩하는 체대생", linkURL: "https://mini-min-dev.tistory.com/", isRead: false, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 1, toastListDto: [ToastList(toastId: 1, toastTitle: "Title", linkURL: "https://linklinklink", isRead: true, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 2, toastListDto: [ToastList(toastId: 1, toastTitle: "코딩하는 체대생", linkURL: "https://mini-min-dev.tistory.com/", isRead: false, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 1, toastListDto: [ToastList(toastId: 1, toastTitle: "Title", linkURL: "https://linklinklink", isRead: true, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")]),
    DetailClipListModel(allToastNum: 2, toastListDto: [ToastList(toastId: 1, toastTitle: "코딩하는 체대생", linkURL: "https://mini-min-dev.tistory.com/", isRead: false, categoryTitle: "어쩌구", toastThubnail: "아직 사진 url 연결 안함")])
]

//
//  DetailClipModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/25/24.
//

import Foundation

struct DetailClipModel {
    let allToastCount: Int
    let toastList: [ToastListModel]
}

struct ToastListModel {
    let id: Int
    let title: String
    let url: String
    let isRead: Bool
    let clipTitle: String?
    let imageURL: String?
}

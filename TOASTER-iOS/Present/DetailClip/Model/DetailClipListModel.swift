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

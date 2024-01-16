//
//  GetDetailCategoryResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct GetDetailCategoryResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetDetailCategoryResponseData
}

struct GetDetailCategoryResponseData: Codable {
    let allToastNum: Int
    let toastListDto: [ToastListDto]
}

// MARK: - ToastListDto
struct ToastListDto: Codable {
    let toastId: Int
    let toastTitle: String
    let linkUrl: String
    let isRead: Bool
    let categoryTitle: String?
    let thumbnailUrl: String?
}

//
//  GetDetailAllCategoryResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct GetDetailAllCategoryResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetDetailAllCategoryResponseData
}

// MARK: - DataClass
struct GetDetailAllCategoryResponseData: Codable {
    let allToastNum: Int
    let toastListDto: [ToastListDTO]
}

// MARK: - ToastListDto
struct ToastListDTO: Codable {
    let toastId: Int
    let toastTitle: String
    let linkUrl: String
    let isRead: Bool
    let categoryTitle: String?
    let thumbnailUrl: String?
}

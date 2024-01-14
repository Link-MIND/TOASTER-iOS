//
//  GetAllCategoryResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct GetAllCategoryResponseDTO: Codable {
    let code: Int
    let message: String
    let data: [GetAllCategoryResponseData]
}

struct GetAllCategoryResponseData: Codable {
    let categoryId: Int
    let categoryTitle: String
    let toastNum: Int
}

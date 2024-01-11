//
//  GetMainPageResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct GetMainPageResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetMainPageResponseData
}

struct GetMainPageResponseData: Codable {
    let nickname: String
    let readToastNum, allToastNum: Int
    let mainCategoryListDto: [MainCategoryListDto]
}

struct MainCategoryListDto: Codable {
    let categoryId: Int
    let categoryTitle: String
    let toastNum: Int
}

//
//  PatchEditCategoryRequestDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct PatchEditCategoryRequestDTO: Codable {
    let changeCategoryTitleList: [ChangeCategoryTitleList]
    let changeCategoryPriorityList: [ChangeCategoryPriorityList]
}

struct ChangeCategoryTitleList: Codable {
    let categoryId: Int
    let newTitle: String
}

struct ChangeCategoryPriorityList: Codable {
    let categoryId, newPriority: Int
}

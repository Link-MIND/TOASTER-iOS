//
//  PatchEditNameCategoryRequestDTO.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/16/24.
//

import Foundation

struct PatchEditNameCategoryRequestDTO: Codable {
    let categoryId: Int
    let newTitle: String
}

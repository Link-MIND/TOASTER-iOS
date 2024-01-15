//
//  PostSaveLinkRequestDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

struct PostSaveLinkRequestDTO: Codable {
    let linkUrl: String
    let categoryId: Int?
}

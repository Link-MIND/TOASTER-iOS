//
//  PatchEditLinkTitleResponseDTO.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/05/05.
//

import Foundation

struct PatchEditLinkTitleResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PatchEditLinkTitleResponseData
}

struct PatchEditLinkTitleResponseData: Codable {
    let updatedTitle: String
}

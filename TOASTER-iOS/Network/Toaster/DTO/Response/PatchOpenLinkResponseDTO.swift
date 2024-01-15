//
//  PatchOpenLinkResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

struct PatchOpenLinkResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PatchOpenLinkResponseData
}

struct PatchOpenLinkResponseData: Codable {
    let isRead: Bool
}

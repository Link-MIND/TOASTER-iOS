//
//  GetSettingPageResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct GetSettingPageResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetSettingPageResponseData
}

struct GetSettingPageResponseData: Codable {
    let nickname: String
    let email: String
    let isFcmAllowed: Bool
}

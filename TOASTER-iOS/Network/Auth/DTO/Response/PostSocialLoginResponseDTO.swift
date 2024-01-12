//
//  PostSocialLoginResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct PostSocialLoginResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PostSocialLoginResponseData
}

struct PostSocialLoginResponseData: Codable {
    let userId: Int
    let refreshToken, accessToken, fcmToken: String
    let isRegistered, fcmIsAllowed: Bool
}

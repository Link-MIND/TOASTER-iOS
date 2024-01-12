//
//  PostRefreshTokenResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct PostRefreshTokenResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PostRefreshTokenResponseData
}

struct PostRefreshTokenResponseData: Codable {
    let accessToken: String
    let refreshToken: String
}

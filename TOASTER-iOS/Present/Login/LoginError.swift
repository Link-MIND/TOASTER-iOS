//
//  LoginError.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/6/24.
//

import Foundation

enum LoginError: Error {
    case notSettingUsecase
    case failedReceiveToken
    
    var description: String {
        switch self {
        case .notSettingUsecase:
            return "🔒 소셜 로그인 설정 불가"
        case .failedReceiveToken:
            return "🔑 토큰을 받지 못했습니다."
        }
    }
}

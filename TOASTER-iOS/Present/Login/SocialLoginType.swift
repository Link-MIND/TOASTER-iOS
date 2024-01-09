//
//  SocialLoginType.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 12/30/23.
//

import UIKit

enum SocialLoginType {
    case kakao, apple
    
    var title: String {
        switch self {
        case .kakao:
            return "카카오 계정으로 시작하기"
        case .apple:
            return "Apple 계정으로 시작하기"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .kakao:
            return .black900
        case .apple:
            return .toasterWhite
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .kakao:
            return .loginKakao
        case .apple:
            return .black850
        }
    }
    
    var logoImage: UIImage {
        switch self {
        case .kakao:
            return ImageLiterals.Login.kakaoLogo
        case .apple:
            return ImageLiterals.Login.appleLogo
        }
    }
}

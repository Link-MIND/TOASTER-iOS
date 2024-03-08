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
            return StringLiterals.Login.kakaoButton
        case .apple:
            return StringLiterals.Login.appleButton
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
            return .icKakaoLogin24
        case .apple:
            return .icAppleLogin24
        }
    }
}

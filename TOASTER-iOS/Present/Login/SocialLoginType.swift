//
//  SocialLoginType.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 12/30/23.
//

import UIKit

enum SocialLoginType: String {
    case kakao, apple
    
    var title: String {
        switch self {
        case .kakao:
            return "Kakao로 시작하기"
        case .apple:
            return "Apple로 시작하기"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .kakao:
            return UIColor.black
        case .apple:
            return UIColor.white
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .kakao:
            return UIColor.yellow
        case .apple:
            return UIColor.black
        }
    }
}

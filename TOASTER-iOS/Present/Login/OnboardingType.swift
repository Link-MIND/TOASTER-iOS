//
//  OnboardingType.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 2/23/24.
//

import UIKit

enum OnboardingType: CaseIterable {
    case first, second, third, fourth
    
    var title: String {
        switch self {
        case .first:
            return StringLiterals.Login.onboarding1
        case .second:
            return StringLiterals.Login.onboarding2
        case .third:
            return StringLiterals.Login.onboarding3
        case .fourth:
            return StringLiterals.Login.subTitle
        }
    }
    
    var image: UIImage {
        switch self {
        case .first:
            return UIImage(resource: .imgOnboarding)
        case .second:
            return UIImage(resource: .imgOnboarding2)
        case .third:
            return UIImage(resource: .imgOnboarding3)
        case .fourth:
            return UIImage(resource: .imgLogin)
        }
    }
}

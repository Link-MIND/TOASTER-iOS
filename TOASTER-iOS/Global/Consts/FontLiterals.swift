//
//  FontLiterals.swift
//  TOASTER-iOS
//
//  Created by 민 on 12/31/23.
//

import UIKit

enum FontName: String {
    case suitExtraBold = "SUIT-ExtraBold"
    case suitBold = "SUIT-Bold"
    case suitSemiBold = "SUIT-SemiBold"
    case suitMedium = "SUIT-Medium"
    case suitRegular = "SUIT-Regular"
}

extension UIFont {
    @nonobjc class func suitExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: FontName.suitExtraBold.rawValue, size: size)!
    }
    
    @nonobjc class func suitBold(size: CGFloat) -> UIFont {
        return UIFont(name: FontName.suitBold.rawValue, size: size)!
    }
    
    @nonobjc class func suitSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: FontName.suitSemiBold.rawValue, size: size)!
    }
    
    @nonobjc class func suitMedium(size: CGFloat) -> UIFont {
        return UIFont(name: FontName.suitMedium.rawValue, size: size)!
    }
    
    @nonobjc class func suitRegular(size: CGFloat) -> UIFont {
        return UIFont(name: FontName.suitRegular.rawValue, size: size)!
    }
}

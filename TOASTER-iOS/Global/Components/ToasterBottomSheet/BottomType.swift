//
//  BottomType.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/3/24.
//

import UIKit

enum BottomType {
    case white, gray
    
    var color: UIColor {
        switch self {
        case .white:
            return .toasterWhite
        case .gray:
            return .gray50
        }
    }
    
    var alignment: NSTextAlignment {
        return .left
    }
}

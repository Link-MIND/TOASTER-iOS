//
//  ToasterToastMessage.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/2/24.
//

import UIKit

enum ToastStatus {
    case check, warning
    
    var icon: UIImage {
        switch self {
        case .check:
            return ImageLiterals.Common.check
        case .warning:
            return ImageLiterals.Common.exclamation
        }
    }
}

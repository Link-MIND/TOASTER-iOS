//
//  ToasterNavigationType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/6/24.
//

import UIKit

struct ToasterNavigationType {
    var hasBackButton: Bool
    var hasRightButton: Bool

    var hasMainImage: Bool
    var mainImage: UIImage?
    var mainTitle: String?
    
    var hasRightButtonImage: Bool
    var rightButtonImage: UIImage?
    var rightButtonTitle: String? 
    var rightButtonAction: () -> Void
}

//
//  ToasterNavigationType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/6/24.
//

import UIKit

struct ToasterNavigationType {
    var hasBackButton: Bool     // backButton 존재 여부
    var hasRightButton: Bool    // rightButton 존재 여부

    var mainTitle: StringOrImageType        // mainTitle
    var rightButton: StringOrImageType      // rightButton
    var rightButtonAction: () -> Void   // rightButton의 액션
}

enum StringOrImageType {
    case string(String)
    case image(UIImage)
}

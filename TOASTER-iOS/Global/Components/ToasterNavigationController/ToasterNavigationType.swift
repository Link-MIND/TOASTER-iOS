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

    var hasMainImage: Bool      // mainTitle이 이미지로 존재하는지
    var mainImage: UIImage?     // mainTitle이 이미지로 존재할 때의 이미지
    var mainTitle: String?      // mainTitle이 String 값일 때의 String값
    
    var hasRightButtonImage: Bool       // rightButton이 이미지로 존재하는지
    var rightButtonImage: UIImage?      // rightButton이 이미지 버튼일 때의 이미지 값
    var rightButtonTitle: String?       // rightButton이 String 버튼일 때의 String 값
    var rightButtonAction: () -> Void   // rightButton의 액션
}

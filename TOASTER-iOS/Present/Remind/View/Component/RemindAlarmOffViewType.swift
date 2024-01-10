//
//  RemindAlarmOffViewType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

enum RemindAlarmOffViewType {
    case normal, bottomSheet
    
    var textAlignment: NSTextAlignment {
        switch self {
        case .normal: return .center
        case .bottomSheet: return .left
        }
    }
    
    var bottomLabelText: String {
        switch self {
        case .normal: return "기존에 설정한 타이머들은 알림을 키면\n다시 복구돼요"
        case .bottomSheet: return "언제든지 기기 설정 > 알림에서 변경이 가능해요"
        }
    }
}

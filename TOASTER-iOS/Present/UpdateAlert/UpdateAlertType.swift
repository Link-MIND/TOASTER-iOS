//
//  UpdateAlertType.swift
//  TOASTER-iOS
//
//  Created by 민 on 4/17/24.
//

import UIKit

enum UpdateAlertType {
    case ForceUpdate        // Major Update case -> 강제 업데이트
    case NoticeUpdate       // Minor 사용성 Update case -> 선택 업데이트
    case NoticeFeatUpdate   // Minor 기능 Update case -> 선택 업데이트
    
    var title: String {
        switch self {
        case .ForceUpdate:
            return "신규 기능 업데이트 알림"
        case .NoticeUpdate:
            return "업데이트 알림"
        case .NoticeFeatUpdate:
            return "기능 업데이트 알림"
        }
    }
    
    var description: String {
        switch self {
        case .ForceUpdate:
            return "토스터의 새로운 기능을 이용하기 위해서는\n업데이트가 필요해요!\n최신 버전으로 업데이트 하시겠어요?"
        case .NoticeUpdate:
            return "토스터의 사용성이 개선되었어요!\n지금 바로 업데이트해보세요"
        case .NoticeFeatUpdate:
            return "토스터의 기능이 추가되었어요!\n지금 바로 업데이트해보세요"
        }
    }
    
}

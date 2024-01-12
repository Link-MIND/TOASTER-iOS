//
//  TimerRepeatDate.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

enum TimerRepeatDate {
    case everyDay, everyWeekDay, everyWeekend
    case mon, tue, wed, thu, fri, sat, sun
    
    var name: String {
        switch self {
        case .everyDay:
            return "매일 (월~일)"
        case .everyWeekDay:
            return "주중마다 (월~금)"
        case .everyWeekend:
            return "주중마다 (토~일)"
        case .mon:
            return "월요일마다"
        case .tue:
            return "화요일마다"
        case .wed:
            return "수요일마다"
        case .thu:
            return "목요일마다"
        case .fri:
            return "금요일마다"
        case .sat:
            return "토요일마다"
        case .sun:
            return "일요일마다"
        }
    }
    
    /// 서버로 보내줄 int값
    var toInt: [Int] {
        switch self {
        case .everyDay:
            return [1, 2, 3, 4, 5, 6, 7]
        case .everyWeekDay:
            return [1, 2, 3, 4, 5]
        case .everyWeekend:
            return [6, 7]
        case .mon:
            return [1]
        case .tue:
            return [2]
        case .wed:
            return [3]
        case .thu:
            return [4]
        case .fri:
            return [5]
        case .sat:
            return [6]
        case .sun:
            return [7]
        }
    }
}

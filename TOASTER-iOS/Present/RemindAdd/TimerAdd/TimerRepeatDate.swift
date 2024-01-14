//
//  TimerRepeatDate.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

/// Date 값에 대한 정의
/// Date 값에 따라 보여줘야 할 String 값과,
/// Date 값을 서버로 보낼 때의 ID 값 (Int)을 정의해둠
enum TimerRepeatDate: Int {
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
    case sun = 7
    case everyDay = 8
    case everyWeekDay = 9
    case everyWeekend = 10
    
    var name: String {
        switch self {
        case .everyDay:
            return "매일 (월~일)"
        case .everyWeekDay:
            return "주중마다 (월~금)"
        case .everyWeekend:
            return "주말마다 (토~일)"
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
    
    var days: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        default: return ""
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

extension Set<Int> {
    
    /// Date의 ID 값을 요일 String으로 바꿔주는 함수
    func fetchDaysString() -> String {
        var text = ""
        var setList = Array(self)
        setList.sort()
        for i in 0..<setList.count {
            if let date = TimerRepeatDate(rawValue: setList[i]) {
                if i == setList.count - 1 {
                    text = text + date.days + "요일 마다"
                } else {
                    text = text + date.days + ", "
                }
            }
        }
        return text
    }
}

//
//  TimerTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

import Moya

enum TimerTargetType {
    case getTimerMainpage
    case postCreateTimer(requestBody: PostCreateTimerRequestDTO)
    case patchEditTimer(timerId: Int,
                        requestBody: PatchEditTimerRequestDTO)
    case deleteTimer(timerId: Int)
    case getDetailTimer(timerId: Int)
    case patchEditTimerTitle(timerId: Int,
                             requestBody: PatchEditTimerTitleRequestDTO)
    case patchEditAlarmTimer(timerId: Int)
}

extension TimerTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .timer }
    
    var pathParameter: String? {
        switch self {
        case .patchEditTimer(let timerId, _), 
                .deleteTimer(let timerId),
                .getDetailTimer(let timerId),
                .patchEditTimerTitle(let timerId, _),
                .patchEditAlarmTimer(let timerId): return String(timerId)
        default: return .none
        }
    }

    var queryParameter: [String: Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postCreateTimer(let body): return body
        case .patchEditTimer(_, let body): return body
        case .patchEditTimerTitle(_, let body): return body
        default: return .none
        }
    }
    
    var path: String {
        switch self {
        case .getTimerMainpage: return utilPath.rawValue + "/main"
        case .postCreateTimer: return utilPath.rawValue
        case .patchEditTimer(let timerId, _): return utilPath.rawValue + "/datetime/\(timerId)"
        case .deleteTimer(let timerId): return utilPath.rawValue + "/\(timerId)"
        case .getDetailTimer(let timerId): return utilPath.rawValue + "/\(timerId)"
        case .patchEditTimerTitle(let timerId, _): return utilPath.rawValue + "/comment/\(timerId)"
        case .patchEditAlarmTimer(let timerId): return utilPath.rawValue + "/alarm/\(timerId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTimerMainpage: return .get
        case .postCreateTimer: return .post
        case .patchEditTimer(let timerId, _): return .patch
        case .deleteTimer(let timerId): return .delete
        case .getDetailTimer(let timerId): return .get
        case .patchEditTimerTitle(let timerId, _): return .patch
        case .patchEditAlarmTimer(let timerId): return .patch
        }
    }
}


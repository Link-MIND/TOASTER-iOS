//
//  UserTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

enum UserTargetType {
    case getSettingPage
    case getMyPage
    case patchPushAlarm(requestBody: PatchPushAlarmRequestDTO)
    case getMainPage
}

extension UserTargetType: BaseTargetType {
    
    var headerType: HeaderType { return .accessTokenHeader }
    
    var utilPath: UtilPath { return .user }
    var pathParameter: String? { return .none }
    var queryParameter: [String : Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .patchPushAlarm(let requestBody): return requestBody
        default: return .none
        }
    }
    
    var path: String {
        switch self {
        case .getSettingPage: return utilPath.rawValue + "/mysettings"
        case .getMyPage: return utilPath.rawValue + "/my-page"
        case .patchPushAlarm(_): return utilPath.rawValue + "/notification"
        case .getMainPage: return utilPath.rawValue + "/main"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSettingPage: return .get
        case .getMyPage: return .get
        case .patchPushAlarm(_): return .patch
        case .getMainPage: return .get
        }
    }
}

//
//  PopupTargetType.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/23/24.
//

import Foundation

import Moya

enum PopupTargetType {
    case getPopupInfo
    case patchEditPopupHidden(requestBody: PatchPopupHiddenRequestDTO)
}

extension PopupTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .popup }
    var pathParameter: String? { return .none }
    var queryParameter: [String: Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .patchEditPopupHidden(let body): return body
        default: return .none
        }
    }
    
    var path: String { return utilPath.rawValue }
    
    var method: Moya.Method {
        switch self {
        case .getPopupInfo: return .get
        case .patchEditPopupHidden: return .patch
        }
    }
}

//
//  ToasterTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

import Moya

enum ToasterTargetType {
    case postSaveLink(requestBody: PostSaveLinkRequestDTO)
    case patchOpenLink(requestBody: PostSaveLinkRequestDTO)
    case deleteLink(toastId: Int)
    case getWeeksLink
}

extension ToasterTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .link }
    var pathParameter: String? { return .none }

    var queryParameter: [String: Any]? {
        switch self {
        case .deleteLink(let toastId):
            return ["toastId" : toastId]
        default: return .none
        }
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postSaveLink(let body): return body
        case .patchOpenLink(let body): return body
        default: return .none
        }
    }
    
    var path: String {
        switch self {
        case .postSaveLink(let body): return utilPath.rawValue + "/save"
        case .patchOpenLink(let body): return utilPath.rawValue + "/is-read"
        case .deleteLink: return utilPath.rawValue + "/delete"
        case .getWeeksLink: return utilPath.rawValue + "/week"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSaveLink(let body): return .post
        case .patchOpenLink(let body): return .patch
        case .deleteLink: return .delete
        case .getWeeksLink: return .get
        }
    }
}


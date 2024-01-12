//
//  ClipTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

enum DetailCategoryFilter: String {
    case all = "ALL"
    case read = "READ"
    case unread = "UNREAD"
}

enum ClipTargetType {
    case postAddCategory(requestBody: PostAddCategoryRequestDTO)
    case getDetailCategory(categoryID: Int, filter: DetailCategoryFilter)
    case deleteCategory(requestBody: DeleteCategoryRequestDTO)
    case patchEditCategory(requestBody: PatchPushAlarmRequestDTO)
    case getAllCategory
    case getCheckCategory(categoryTitle: String)
}

extension ClipTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .clip }
    
    var pathParameter: String? {
        switch self {
        case .getDetailCategory(let categoryID, _): return "\(categoryID)"
        default: return .none
        }
    }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getDetailCategory(_, let filter):
            return ["filter": filter.rawValue]
        case .getCheckCategory(let categoryTitle):
            return ["title": categoryTitle]
        default: return .none
        }
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postAddCategory(let body): return body
        case .deleteCategory(let body): return body
        case .patchEditCategory(let body): return body
        default: return .none
        }
    }
    
    var path: String {
        switch self {
        case .postAddCategory(_): return utilPath.rawValue
        case .getDetailCategory(let categoryID, _):
            return utilPath.rawValue + "\(categoryID)"
        case .deleteCategory(_): return utilPath.rawValue
        case .patchEditCategory(_): return utilPath.rawValue + "/edit"
        case .getAllCategory: return utilPath.rawValue + "/all"
        case .getCheckCategory(_): return utilPath.rawValue + "/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postAddCategory(_): return .post
        case .getDetailCategory(_, _): return .get
        case .deleteCategory(_): return .delete
        case .patchEditCategory(_): return .patch
        case .getAllCategory: return .get
        case .getCheckCategory(_): return .get
        }
    }
}

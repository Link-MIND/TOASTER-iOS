//
//  SearchTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

import Moya

enum SearchTargetType {
    case getMainPageSearch(searchText: String)
    case getRecommendSite
}

extension SearchTargetType: BaseTargetType {
    var headerType: HeaderType { return .accessTokenHeader }
    var utilPath: UtilPath { return .search }
    
    var pathParameter: String? { return .none }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getMainPageSearch(let searchText):
            return ["query": searchText]
        default: return .none
        }
    }
    
    var requestBodyParameter: Codable? { return .none }
    
    var path: String {
        switch self {
        case .getMainPageSearch: return utilPath.rawValue + "/main/search"
        case .getRecommendSite: return utilPath.rawValue + "sites"
        }
    }
    
    var method: Moya.Method { return .get }
}

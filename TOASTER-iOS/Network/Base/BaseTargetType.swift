//
//  BaseTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

///  헤더에 들어가는 토큰의 상태에 따른 Type
enum HeaderType {
    case nonHeader
    case accessTokenHeader
    case refreshTokenHeader
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum UtilPath: String {
    case auth = "auth"
    case user = "user"
    case link = "toast"
    case clip = "category"
    case search = ""
    case timer = "timer"
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
    var utilPath: UtilPath { get }
    var pathParameter: String? { get }
    var queryParameter: [String : Any]? { get }
    var requestBodyParameter: Codable? { get }
}

extension BaseTargetType {
    
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("🍞⛔️ Base URL이 없어요! ⛔️🍞")
        }
        return baseURL
    }
    
    // TODO: - 로그인 API 부착 후 토큰 로직 변경
    
    var headers: [String : String]? {
        var header = ["Content-Type": "application/json"]
        
        switch headerType {
        case .accessTokenHeader:
            header["accessToken"] = Config.tempToken
        case .refreshTokenHeader:
            header["refreshToken"] = ""
        default: break
        }
        
        return header
    }
    
    var task: Task {
        if let parameter = queryParameter {
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        }
        if let parameter = requestBodyParameter {
            return .requestJSONEncodable(parameter)
        }
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
}

//
//  BaseTargetType.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

enum TokenHealthType {
    case accessToken
    case refreshToken
}

///  헤더에 들어가는 토큰의 상태에 따른 Type
enum HeaderType {
    case socialTokenHeader(socialToken: String)
    case accessTokenHeader
    case refreshTokenHeader
    case tokenHealthHeader(tokenHealthType: TokenHealthType)
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
    var queryParameter: [String: Any]? { get }
    var requestBodyParameter: Codable? { get }
}

extension BaseTargetType {
    
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("🍞⛔️ Base URL이 없어요! ⛔️🍞")
        }
        return baseURL
    }
        
    var headers: [String: String]? {
        var header = ["Content-Type": "application/json"]
        
        switch headerType {
        case .socialTokenHeader(let socialToken):
            header["Authorization"] = socialToken
        case .accessTokenHeader:
            header["accessToken"] = KeyChainService.loadAccessToken(key: Config.accessTokenKey)
        case .refreshTokenHeader:
            header["refreshToken"] = KeyChainService.loadRefreshToken(key: Config.refreshTokenKey)
        case .tokenHealthHeader(let tokenHealthType):
            switch tokenHealthType {
            case .accessToken:
                header["token"] = KeyChainService.loadAccessToken(key: Config.accessTokenKey)
            case .refreshToken:
                header["token"] = KeyChainService.loadAccessToken(key: Config.accessTokenKey)
            }
        }
        
        return header
    }
    
    var task: Task {
        if let queryParameter {
            return .requestParameters(parameters: queryParameter, encoding: URLEncoding.default)
        }
        if let requestBodyParameter {
            return .requestJSONEncodable(requestBodyParameter)
        }
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

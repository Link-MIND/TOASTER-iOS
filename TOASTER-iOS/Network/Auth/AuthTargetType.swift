//
//  AuthAPI.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

enum AuthTargetType {
    case postSocialLogin(socialToken: String,
                         requestBody: PostSocialLoginRequestDTO)
    case postRefreshToken
    case postLogout
    case deleteWithdraw
    case postTokenHealth(tokenType: TokenHealthType)
}

extension AuthTargetType: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .postSocialLogin(let socialToken, _): return .socialTokenHeader(socialToken: socialToken)
        case .postRefreshToken: return .refreshTokenHeader
        case .postTokenHealth(let tokenType): return .tokenHealthHeader(tokenHealthType: tokenType)
        default: return .accessTokenHeader
        }
    }
    
    var utilPath: UtilPath { return .auth }
    var pathParameter: String? { return .none }
    var queryParameter: [String: Any]? { return .none }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postSocialLogin(_, let requestBody): return requestBody
        default: return .none
        }
    }
    
    var path: String {
        switch self {
        case .postSocialLogin: return utilPath.rawValue
        case .postRefreshToken: return utilPath.rawValue + "/token"
        case .postLogout: return utilPath.rawValue + "/sign-out"
        case .deleteWithdraw: return utilPath.rawValue + "/withdraw"
        case .postTokenHealth: return utilPath.rawValue + "/token/health"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSocialLogin: return .post
        case .postRefreshToken: return .post
        case .postLogout: return .post
        case .deleteWithdraw: return .delete
        case .postTokenHealth: return .post
        }
    }
}

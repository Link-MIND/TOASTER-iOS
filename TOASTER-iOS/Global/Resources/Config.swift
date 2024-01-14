//
//  Config.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/4/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
            static let baseURL = "BASE_URL"
            static let tempToken = "TEMP_ACCESS_TOKEN"
            static let accessTokenKey = "ACCESS_TOKEN_KEY"
            static let refreshTokenKey = "REFRESH_TOKEN_KEY"
            static let loginType = "LOGIN_TYPE"
            static let appleLogin = "APPLE_LOGIN"
            static let kakaoLogin = "KAKAO_LOGIN"
            static let appleUserID =  "APPLE_USER_ID"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}

extension Config {
    static let kakaoNativeAppKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("🍞⛔️KAKAO_NATIVE_APP_KEY is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let baseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("🍞⛔️BASE_URL is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let tempToken: String = {
        guard let key = Config.infoDictionary[Keys.Plist.tempToken] as? String else {
            fatalError("🍞⛔️TEMP_ACCESS_TOKEN is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let accessTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.accessTokenKey] as? String else {
            fatalError("🍞⛔️ACCESS_TOKEN_KEY is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let refreshTokenKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.refreshTokenKey] as? String else {
            fatalError("🍞⛔️REFRESH_TOKEN_KEY is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let loginType: String = {
        guard let key = Config.infoDictionary[Keys.Plist.loginType] as? String else {
            fatalError("🍞⛔️LOGIN_TYPE is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let appleLogin: String = {
        guard let key = Config.infoDictionary[Keys.Plist.appleLogin] as? String else {
            fatalError("🍞⛔️APPLE_LOGIN is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let kakaoLogin: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoLogin] as? String else {
            fatalError("🍞⛔️KAKAO_LOGIN is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
    static let appleUserID: String = {
        guard let key = Config.infoDictionary[Keys.Plist.appleUserID] as? String else {
            fatalError("🍞⛔️APPLE_USER_ID is not set in plist for this configuration⛔️🍞")
        }
        return key
    }()
    
}

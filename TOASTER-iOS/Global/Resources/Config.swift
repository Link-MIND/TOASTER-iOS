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
            static let kakaoNativeAppKey = "KakaoNativeAppKey"
            static let baseURL = "BASE_URL"
            static let tempToken = "TEMP_ACCESS_TOKEN"
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
}

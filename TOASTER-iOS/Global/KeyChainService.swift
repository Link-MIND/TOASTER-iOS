//
//  KeyChainService.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/11/24.
//

import Foundation

import Security

struct KeyChainService {
    
    //MARK: - static func
    
    static func saveAccessToken(accessToken: String, key: String) {
        saveToken(token: accessToken, key: key)
    }
    
    static func saveRefreshToken(refreshToken: String, key: String) {
        
    }
    
    static func loadAccessToken(key: String) -> String? {
        
    }
    
    static func loadRefreshToken(key: String) -> String? {
        
    }
    
    //MARK: - private static func
    
    private static func saveToken(token: String, key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
        
        ]
    }
    
    private static func loadToken(token: String, key: String) {
        
    }
    
    private static func deleteToken() {
        
    }
}

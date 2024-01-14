//
//  KeyChainService.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/11/24.
//

import Foundation
import Security

struct KeyChainService {
    
    // MARK: - static func
    
    static func saveAccessToken(accessToken: String, key: String) -> Bool {
        let result = saveToken(token: accessToken, key: key)
        return result
    }
    
    static func saveRefreshToken(refreshToken: String, key: String) -> Bool {
        let result = saveToken(token: refreshToken, key: key)
        return result
    }
    
    static func saveTokens(accessKey: String, refreshKey: String) -> (accessResult: Bool, refreshResult: Bool) {
        let accessResult = saveToken(token: accessKey, key: Config.accessTokenKey)
        let refreshResult = saveToken(token: refreshKey, key: Config.refreshTokenKey)
        return (accessResult: accessResult, refreshResult: refreshResult)
    }
    
    static func loadAccessToken(key: String) -> String? {
        let result = loadToken(key: key)
        return result
    }
    
    static func loadRefreshToken(key: String) -> String? {
        let result = loadToken(key: key)
        return result
    }
    
    static func deleteAccessToken(key: String) -> Bool {
        let result = deleteToken(key: key)
        return result
    }
    
    static func deleteRefreshToken(key: String) -> Bool {
        let result = deleteToken(key: key)
        return result
    }
    
    static func loadTokens(accessKey: String, refreshKey: String) -> (access: String?, refresh: String?) {
        let accessResult = loadToken(key: accessKey)
        let refreshResult = loadToken(key: refreshKey)
        return (access: accessResult, refresh: refreshResult)
    }
    
    // MARK: - private static func
    
    private static func saveToken(token: String, key: String) -> Bool {
        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]

            let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
            
            switch status {
            case errSecItemNotFound:
                // 기존 데이터가 없으면 새로운 아이템으로 추가
                let addStatus = SecItemAdd(query as CFDictionary, nil)
                
                if addStatus == errSecSuccess {
                    if key == Config.accessTokenKey {
                        print("🍞⛔️KeyChain - AccessToken 저장 성공⛔️🍞")
                    } else {
                        print("🍞⛔️KeyChain - RefreshToken 저장 성공⛔️🍞")
                    }
                    return true
                } else {
                    if key == Config.accessTokenKey {
                        print("🍞⛔️KeyChain - AccessToken 저장 실패 (Error:\(addStatus) )⛔️🍞")
                    } else {
                        print("🍞⛔️KeyChain - RefreshToken 저장 실패 (Error:\(addStatus))⛔️🍞")
                    }
                    return false
                }
            case errSecSuccess:
                // 업데이트 성공
                if key == Config.accessTokenKey {
                    print("🍞⛔️KeyChain - AccessToken 업데이트 성공⛔️🍞")
                } else {
                    print("🍞⛔️KeyChain - RefreshToken 업데이트 성공⛔️🍞")
                }
                return true
            default:
                // 다른 오류 발생
                print("🍞⛔️Keychain save error: \(status)⛔️🍞")
                return false
            }
        }
        
        // 데이터 변환 실패
        print("🍞⛔️Keychain - 데이터 변환 실패⛔️🍞")
        return false
    }
    
    private static func loadToken(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne // 중복되는 경우, 하나의 값만 불러오기
        ]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        
        if status == errSecSuccess, let tokenData = data as? Data,
            let token = String(data: tokenData, encoding: .utf8) {
            
            if key == Config.accessTokenKey {
                print("🍞⛔️KeyChain - AccessToken 불러오기 성공⛔️🍞")
            } else {
                print("🍞⛔️KeyChain - RefreshToken 불러오기 성공⛔️🍞")
            }
            return token
        } else if status == errSecItemNotFound {
            // 해당 키에 대한 아이템이 없는 경우
            if key == Config.accessTokenKey {
                print("🍞⛔️KeyChain - AccessToken 존재하지 않음⛔️🍞")
            } else {
                print("🍞⛔️KeyChain - RefreshToken 존재하지 않음⛔️🍞")
            }
            return nil
        } else {
            // 다른 오류 발생
            print("🍞⛔️Keychain load error: \(status)⛔️🍞")
            return nil
        }
    }
    
    private static func deleteToken(key: String) -> Bool {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query)
        
        switch status {
        case errSecItemNotFound:
            // 기존 데이터가 없음
            print("🍞⛔️KeyChain Key 존재하지 않음⛔️🍞")
            return false
        case errSecSuccess:
            // 삭제 성공
            print("🍞⛔️KeyChain 삭제 성공⛔️🍞")
            return true
        default:
            // 다른 오류 발생
            print("🍞⛔️Keychain error: \(status)")
            return false
        }
    }
}

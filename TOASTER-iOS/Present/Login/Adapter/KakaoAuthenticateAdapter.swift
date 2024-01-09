//
//  KakaoAuthenticateAdapter.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/4/24.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

final class KakaoAuthenticateAdapter: NSObject, AuthenticationAdapterProtocol {

    var adapterType: String {
        return "Kakao Adapter"
    }
    
    func login() async throws -> SocialLoginTokenModel {
        /// 카카오톡 어플리케이션이 설치가 되어 있는지 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            do {
                let result = try await getLoginToken()
                return result
            } catch {
                print("Error during KakaoTalk login: \(error)")
                throw error
            }
        } else {
            do {
                let result = try await getTokenKakaoAccount()
                return result
            } catch {
                print("Error during Kakao account: \(error)")
                throw error
            }
        }
    }
    
    func logout() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(throwing: error)
                } else {
                    print("KakaoTalk Logout success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }

    /// 카카오톡 간편로그인을 통해 토큰을 받아오는 메서드
    @MainActor
    func getLoginToken() async throws -> SocialLoginTokenModel {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(throwing: error)
                } else {
                    print("KakaoTalk Login success.")
                    
                    let accessToken = oauthToken?.accessToken
                    let refreshToken = oauthToken?.refreshToken
                    
                    continuation.resume(returning: SocialLoginTokenModel(accessToken: accessToken, refreshToken: refreshToken))
                }
            }
        }
    }
    
    /// 카카오톡 간편로그인을 할 수 없는 경우 웹에서 이메일로 로그인 해서 토큰을 받아오는 메서드
    @MainActor
    func getTokenKakaoAccount() async throws -> SocialLoginTokenModel {
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(throwing: error)
                } else {
                    print("KakaoAccount Login success.")
                    
                    let accessToken = oauthToken?.accessToken
                    let refreshToken = oauthToken?.refreshToken
                    
                    continuation.resume(returning: SocialLoginTokenModel(accessToken: accessToken, refreshToken: refreshToken))
                }
            }
        }
    }
}

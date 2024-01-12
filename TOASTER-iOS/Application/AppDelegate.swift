//
//  AppDelegate.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import AuthenticationServices
import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isLogin = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        let result = KeyChainService.loadTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
        
        /// 서버에서 발급받은 토큰이 있는 경우
        if (result.access != nil) && (result.refresh != nil) {
            isLogin = true
        } else {
            if let loginType = UserDefaults.standard.string(forKey: StringLiterals.UserDefaultsKey.LoginType) {
                print("Login Type: \(loginType)")
                
                switch loginType {
                case StringLiterals.UserDefaultsKey.apple:
                    checkAppleLogin { [weak self] result in
                        self?.isLogin = result
                    }
                case StringLiterals.UserDefaultsKey.kakao:
                    checkKakaoLogin { [weak self] result in
                        self?.isLogin = result
                    }
                default:
                    break
                }
            } else {
                // 값이 없다면, 기본값 또는 다른 처리를 수행
                print("Login Type이 설정되지 않았습니다.")
                isLogin = false
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkKakaoLogin(completion: @escaping (Bool) -> Void) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        // 로그인 필요
                        print("토큰 만료, 카카오 로그인 필요")
                        completion(false)
                    } else {
                        // 기타 에러
                        completion(false)
                    }
                } else {
                    // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    print("카카오 토큰 유효성 체크 성공")
                    completion(true)
                }
            }
        } else {
            // 카카오 토큰 없음, 로그인 필요
            print("발급받은 토큰 없음, 카카오 로그인 필요")
            completion(false)
        }
    }
    
    func checkAppleLogin(completion: @escaping (Bool) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: StringLiterals.UserDefaultsKey.appleUserID) ?? "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("해당 ID는 연동되어있습니다.")
                completion(true)
            case .revoked:
                print("해당 ID는 연동되어있지않습니다.")
                completion(false)
            case .notFound:
                print("해당 ID를 찾을 수 없습니다.")
                completion(false)
            default:
                break
            }
        }
    }
}


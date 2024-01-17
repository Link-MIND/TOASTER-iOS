//
//  AppDelegate.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import AuthenticationServices
import UIKit

import FirebaseCore
import FirebaseMessaging
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var isLogin = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - 푸시알림 설정
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        // MARK: - 앱 내 알림 기본 설정
        
        UserDefaults.standard.set(true, forKey: "isAppAlarmOn")
        
        // MARK: - 카카오 로그인 설정

        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        let result = KeyChainService.loadTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
        
        /// 서버에서 발급받은 토큰이 있는 경우
        if (result.access != nil) && (result.refresh != nil) {
            isLogin = true
            print("Login 되어있음")
        } else {
            /// 서버에서 발급 받은 토큰이 존재하지 않지만 한번이라도 로그인을 했을 경우 해당 소셜 로그인 유효성 체크
            if let loginType = UserDefaults.standard.string(forKey: Config.loginType) {
                print("Login Type: \(loginType)")
                
                switch loginType {
                case Config.appleLogin:
                    checkAppleLogin { [weak self] result in
                        self?.isLogin = result
                    }
                case Config.kakaoLogin:
                    checkKakaoLogin { [weak self] result in
                        self?.isLogin = result
                    }
                default:
                    break
                }
            } else {
                /// 단 한번도 로그인을 하지 않은 경우
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
        appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: Config.appleUserID) ?? "") { (credentialState, error) in
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

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    // FCM 토큰을 받았을 때 실행
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            KeyChainService.saveFCMToken(fcmToken: token, key: Config.fcmTokenKey)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 실행중일 때, 화면이 켜져있을 때 실행
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let navigationViewController = UIApplication.shared.keyWindow?.rootViewController as? ToasterNavigationController {
            navigationViewController.popToRootViewController(animated: false)
            if let tabBarControlelr = navigationViewController.topViewController as? TabBarController {
                tabBarControlelr.selectedIndex = 3
            }
        }
    }
}

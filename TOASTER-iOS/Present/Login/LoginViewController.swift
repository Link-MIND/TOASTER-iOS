//
//  LoginViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var loginUseCase: LoginUseCase?
    
    // MARK: - UI Properties
    
    private let kakaoSocialLoginButtonView = SocialLoginButtonView(type: .kakao)
    private let appleSocialLoginButtonView = SocialLoginButtonView(type: .apple)
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
}

// MARK: - Private Extensions

private extension LoginViewController {
    func setupStyle() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubviews(kakaoSocialLoginButtonView, appleSocialLoginButtonView)
    }
    
    func setupLayout() {
        kakaoSocialLoginButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalTo(appleSocialLoginButtonView.snp.top).offset(-15)
        }
        
        appleSocialLoginButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    func setupAddTarget() {
        kakaoSocialLoginButtonView.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        appleSocialLoginButtonView.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
    }
    
    /// 할당된 Social Login Adapter 를  통해 loginUseCase 로 Login 실행
    /// - Returns: SocialLogin 을 통해 반환받은 Token 을 SocialLoginTokenModel 로 반환,
    /// Social Login Adapter 가 할당되지 않았을 때 LoginError 반환
    func attemptLogin() async throws -> SocialLoginTokenModel {
        guard let loginUseCase = self.loginUseCase else {
            throw LoginError.notSettingUsecase
        }
        
        do {
            let result = try await loginUseCase.login()
            return result
        } catch let error {
            print("Login Error:", error.localizedDescription)
            throw LoginError.failedReceiveToken
        }
    }
    
    /// 회원가입/로그인 API 요청을 위한 메서드
    /// - Parameters:
    ///   - token: Social Login 을 통해 전달받은 AccessToken
    ///   - socialType: Social Login Tpye ( KAKAO, APPLE )
    /// - Returns: Token 을 KeyChain 에 저장하여 최종적으로 Login 성공시 true,
    /// 서버 통신 중 NetworkResult 타입에 의거하여 success 이외 에 따른 결과는 false,
    /// 서버 통신 결과값을 Decoding 하는 과정 중 생길 수 있는 오류를 LoginError 타입으로 반환
    func fetchTokenSocialLogin(token: String, socialType: String) async throws-> Bool {
        return try await withCheckedThrowingContinuation { continuation in
        
            NetworkService.shared.authService.postSocialLogin(socialToken: token, requestBody: PostSocialLoginRequestDTO(socialType: socialType, fcmToken: nil)) { result in
                switch result {
                case .success(let response):
                    /// Decoding 하는 과정 중 생길 수 있는 오류
                    guard let serverAccessToken = response?.data.accessToken, let serverRefreshToken = response?.data.refreshToken else { return continuation.resume(throwing: LoginError.failedReceiveToken) }
                    
                    let keyChainResult = KeyChainService.saveTokens(accessKey: serverAccessToken, refreshKey: serverRefreshToken)
                    
                    if keyChainResult.accessResult == true && keyChainResult.refreshResult == true {
                        print("Token 저장")
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                case .decodeErr, .networkFail:
                    continuation.resume(returning: false)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    /// 로그인 성공 시 보여줄 ViewController 처리하는 메서드
    func loginSuccess() {
        let tabBarController = TabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = tabBarController
            }
        }
    }

    // MARK: - @objc
    
    @objc func kakaoButtonTapped() {
        loginUseCase = LoginUseCase(adapter: KakaoAuthenticateAdapter())
        
        Task {
            do {
                let result = try await attemptLogin()
                
                guard let kakaoAccessToken = result.accessToken else { return print("Kakao Login Error:", LoginError.failedReceiveToken) }
                
                let serverResult = try await fetchTokenSocialLogin(token: kakaoAccessToken, socialType: "KAKAO")
        
                if serverResult == true {
                    UserDefaults.standard.set("\(Config.kakaoLogin)", forKey: Config.loginType)
                    loginSuccess()
                }
            } catch {
                guard let error = error as? LoginError else { return }
                switch error {
                case .notSettingUsecase:
                    print(error.description)
                case .failedReceiveToken:
                    print(error.description)
                }
            }
        }
    }
    
    @objc func appleButtonTapped() {
        loginUseCase = LoginUseCase(adapter: AppleAuthenticateAdapter())
        
        Task {
            do {
                let result = try await attemptLogin()
                
                guard let appleIdentityToken = result.identityToken else { return print("Apple Login Error:", LoginError.failedReceiveToken) }
                
                let serverResult = try await fetchTokenSocialLogin(token: appleIdentityToken, socialType: "APPLE")
                
                if serverResult == true {
                    UserDefaults.standard.set(Config.appleLogin, forKey: Config.loginType)
                    loginSuccess()
                }
            } catch let error {
                print("Apple Login Error:", error)
            }
        }
    }
}

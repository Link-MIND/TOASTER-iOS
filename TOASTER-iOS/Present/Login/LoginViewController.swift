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
    
    // MARK: - @objc
    
    @objc func kakaoButtonTapped() {
        loginUseCase = LoginUseCase(adapter: KakaoAuthenticateAdapter())
        
        Task {
            do {
                let result = try await attemptLogin()
                
                // 서버로 accessToken 전달
                
                UserDefaults.standard.set("\(StringLiterals.UserDefaultsKey.kakao)", forKey: StringLiterals.UserDefaultsKey.LoginType)
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
                
                if let unwrappedToken = result.identityToken {
                    
                    // 서버로 identity Token 전달
                    
                    UserDefaults.standard.set("\(StringLiterals.UserDefaultsKey.apple)", forKey: StringLiterals.UserDefaultsKey.LoginType)
                } else {
                    print("Apple Login Error:", LoginError.failedReceiveToken)
                }
            } catch let error {
                print("Apple Login Error:", error)
            }
        }
    }
}

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
    private let titleLogoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let loginImageView = UIImageView()
    
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
        hideNavigationBar()
        
        titleLogoImageView.do {
            $0.image = ImageLiterals.Logo.wordmark
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = StringLiterals.Login.Title.subTitle
            $0.textColor = .black900
            $0.font = .suitBold(size: 18)
            $0.numberOfLines = 0
        }
        
        loginImageView.do {
            $0.image = ImageLiterals.Login.loginLogo
            $0.contentMode = .scaleAspectFit//.scaleAspectFit
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(titleLogoImageView, titleLabel, loginImageView, kakaoSocialLoginButtonView, appleSocialLoginButtonView)
    }
    
    func setupLayout() {
        titleLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(115))
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(39)
            $0.width.equalTo(215)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLogoImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(32)
            $0.height.equalTo(45)
        }
        
        loginImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(60))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(loginImageView.snp.height).multipliedBy(304/294)
            $0.bottom.equalTo(appleSocialLoginButtonView.snp.top).inset(-10)
        }
        
        appleSocialLoginButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(kakaoSocialLoginButtonView.snp.top).inset(-12)
            $0.height.equalTo(62)
        }
        
        kakaoSocialLoginButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(62)
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
                
                UserDefaults.standard.set("\(Config.kakaoLogin)", forKey: Config.loginType)
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
                    
                    UserDefaults.standard.set(Config.appleLogin, forKey: Config.loginType)
                } else {
                    print("Apple Login Error:", LoginError.failedReceiveToken)
                }
            } catch let error {
                print("Apple Login Error:", error)
            }
        }
    }
}

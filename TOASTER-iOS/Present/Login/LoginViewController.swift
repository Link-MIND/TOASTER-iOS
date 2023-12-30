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
    
    // MARK: - @objc
    
    @objc func kakaoButtonTapped() {
        print("kakaoButton 눌림")
    }
    
    @objc func appleButtonTapped() {
        print("appleButton 눌림")
    }
}

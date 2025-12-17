//
//  LoginViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 12/16/25.
//

import Combine
import UIKit

final class LoginViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    
    // MARK: - Input State
    
    struct Input {
        let kakaoLoginButtonTapped: Driver<Void>
        let appleLoginButtonTapped: Driver<Void>
    }
    
    // MARK: - Output State
    
    struct Output {
        let loginSucceeded = PassthroughSubject<SocialLoginType, Never>()
        let loginFailed = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Cancellable Bag
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.kakaoLoginButtonTapped
            .sink { [weak self] in
                self?.runLoginFlow(type: .kakao, output: output)
            }.store(in: cancelBag)
        
        input.appleLoginButtonTapped
            .sink { [weak self] in
                self?.runLoginFlow(type: .apple, output: output)
            }.store(in: cancelBag)
        
        return output
    }    
}

// MARK: - Network

private extension LoginViewModel {
    func runLoginFlow(type: SocialLoginType, output: Output) {
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let tokenFromSocialLogin = try await fetchSocialToken(type)
                let serverResult = try await fetchTokenSocialLogin(
                    token: tokenFromSocialLogin,
                    socialType: type.serverValue
                )
                if serverResult == true {
                    UserDefaults.standard.set(type.userDefaultsValue, forKey: Config.loginType)
                    output.loginSucceeded.send(type)
                } else {
                    output.loginFailed.send("로그인에 실패했어요. 잠시 후 다시 시도해 주세요.")
                }
            } catch let error {
                print("\(type.serverValue) Login Error:", error)
                output.loginFailed.send("로그인 중 오류가 발생했어요.")
            }
        }
    }

    /// 할당된 Social Login Adapter를  통해 loginUseCase 로 Login 실행
    /// - Returns:
    func fetchSocialToken(_ type: SocialLoginType) async throws -> String {
        switch type {
        case .kakao:
            let result = try await LoginUseCase(adapter: KakaoAuthenticateAdapter()).login()
            guard let kakaoAccessToken = result.accessToken else {
                print("Kakao Login Error:", LoginError.failedReceiveToken)
                throw LoginError.failedReceiveToken
            }
            return kakaoAccessToken
            
        case .apple:
            let result = try await LoginUseCase(adapter: AppleAuthenticateAdapter()).login()
            guard let appleIdentityToken = result.identityToken else {
                print("Apple Login Error:", LoginError.failedReceiveToken)
                throw LoginError.failedReceiveToken
            }
            return appleIdentityToken
        }
    }
    
    /// 회원가입/로그인 API 요청을 위한 메서드
    /// - Parameters:
    ///   - token: Social Login 을 통해 전달받은 AccessToken
    ///   - socialType: Social Login Tpye ( KAKAO, APPLE )
    /// - Returns: Token 을 KeyChain 에 저장하여 최종적으로 Login 성공시 true,
    /// 서버 통신 중 NetworkResult 타입에 의거하여 success 이외 에 따른 결과는 false,
    /// 서버 통신 결과값을 Decoding 하는 과정 중 생길 수 있는 오류를 LoginError 타입으로 반환
    func fetchTokenSocialLogin(token: String, socialType: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
        
            NetworkService.shared.authService.postSocialLogin(
                socialToken: token,
                requestBody: PostSocialLoginRequestDTO(
                    socialType: socialType,
                    fcmToken: KeyChainService.loadFCMToken(key: Config.fcmTokenKey) ?? ""
                )
            ) { result in
                switch result {
                case .success(let response):
                    /// Decoding 하는 과정 중 생길 수 있는 오류
                    guard let serverAccessToken = response?.data.accessToken, let serverRefreshToken = response?.data.refreshToken else { return continuation.resume(throwing: LoginError.failedReceiveToken) }
                    
                    let keyChainResult = KeyChainService.saveTokens(accessKey: serverAccessToken, refreshKey: serverRefreshToken)
                    
                    if keyChainResult.accessResult == true && keyChainResult.refreshResult == true {
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
}

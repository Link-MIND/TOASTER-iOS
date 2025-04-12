//
//  AuthAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Combine
import Foundation

import Moya

protocol AuthAPIServiceProtocol {
    func postSocialLogin(socialToken: String, requestBody: PostSocialLoginRequestDTO) -> AnyPublisher<PostSocialLoginResponseDTO, ToasterError>
    
    func postRefreshToken() -> AnyPublisher<PostRefreshTokenResponseDTO, ToasterError>
    
    func postLogout() -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func deleteWithdraw() -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func postTokenHealth(tokenType: TokenHealthType) -> AnyPublisher<PostTokenHealthResponseDTO, ToasterError>
}

final class AuthAPIService: BaseAPIService<AuthTargetType>, AuthAPIServiceProtocol {
    private let provider = MoyaProvider<AuthTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func postSocialLogin(socialToken: String, requestBody: PostSocialLoginRequestDTO) -> AnyPublisher<PostSocialLoginResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .postSocialLogin(socialToken: socialToken, requestBody: requestBody),
            responseType: PostSocialLoginResponseDTO.self
        )
    }
    
    func postRefreshToken() -> AnyPublisher<PostRefreshTokenResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .postRefreshToken,
            responseType: PostRefreshTokenResponseDTO.self
        )
    }
    
    func postLogout() -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(provider: provider, target: .postLogout)
    }
    
    func deleteWithdraw() -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(provider: provider, target: .deleteWithdraw)
    }
    
    func postTokenHealth(tokenType: TokenHealthType) -> AnyPublisher<PostTokenHealthResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .postTokenHealth(tokenType: tokenType),
            responseType: PostTokenHealthResponseDTO.self
        )
    }
}

//
//  AuthAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

protocol AuthAPIServiceProtocol {
    func postSocialLogin(socialToken: String,
                         requestBody: PostSocialLoginRequestDTO,
                         completion: @escaping (NetworkResult<PostSocialLoginResponseDTO>) -> Void)
    func postRefreshToken(completion: @escaping (NetworkResult<PostRefreshTokenResponseDTO>) -> Void)
    func postLogout(completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func deleteWithdraw(completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func postTokenHealth(tokenType: TokenHealthType,
                         completion: @escaping (NetworkResult<PostTokenHealthResponseDTO>) -> Void)
}

final class AuthAPIService: BaseAPIService, AuthAPIServiceProtocol {
    
    private let provider = MoyaProvider<AuthTargetType>.init(session: Session(interceptor: APIInterceptor.shared), plugins: [MoyaPlugin()])
    
    func postSocialLogin(socialToken: String,
                         requestBody: PostSocialLoginRequestDTO,
                         completion: @escaping (NetworkResult<PostSocialLoginResponseDTO>) -> Void) {
        provider.request(.postSocialLogin(socialToken: socialToken, requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostSocialLoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostSocialLoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postRefreshToken(completion: @escaping (NetworkResult<PostRefreshTokenResponseDTO>) -> Void) {
        provider.request(.postRefreshToken) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostRefreshTokenResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostRefreshTokenResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postLogout(completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.postLogout) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NoneDataResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<NoneDataResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func deleteWithdraw(completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.deleteWithdraw) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NoneDataResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<NoneDataResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postTokenHealth(tokenType: TokenHealthType,
                         completion: @escaping (NetworkResult<PostTokenHealthResponseDTO>) -> Void) {
        provider.request(.postTokenHealth(tokenType: tokenType)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostTokenHealthResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PostTokenHealthResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}

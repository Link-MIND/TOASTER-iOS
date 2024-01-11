//
//  AuthAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

protocol AuthAPIServiceProtocol {
    func postSocialLogin(requestBody: PostSocialLoginRequestDTO,
                         completion: @escaping (NetworkResult<PostSocialLoginResponseDTO>) -> ())
    func postRefreshToken(completion: @escaping (NetworkResult<PostRefreshTokenResponseDTO>) -> ())
    func postLogout(completion: @escaping (NetworkResult<PostLogoutResponseDTO>) -> ())
    func deleteWithdraw(completion: @escaping (NetworkResult<DeleteWithdrawResponseDTO>) -> ())
}

final class AuthAPIService: BaseAPIService, AuthAPIServiceProtocol {
    
    private let provider = MoyaProvider<AuthTargetType>(plugins: [MoyaPlugin()])
    
    func postSocialLogin(requestBody: PostSocialLoginRequestDTO, 
                         completion: @escaping (NetworkResult<PostSocialLoginResponseDTO>) -> ()) {
        provider.request(.postSocialLogin(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostSocialLoginResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func postRefreshToken(completion: @escaping (NetworkResult<PostRefreshTokenResponseDTO>) -> ()) {
        provider.request(.postRefreshToken) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostRefreshTokenResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func postLogout(completion: @escaping (NetworkResult<PostLogoutResponseDTO>) -> ()) {
        provider.request(.postLogout) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PostLogoutResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func deleteWithdraw(completion: @escaping (NetworkResult<DeleteWithdrawResponseDTO>) -> ()) {
        provider.request(.deleteWithdraw) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<DeleteWithdrawResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
}


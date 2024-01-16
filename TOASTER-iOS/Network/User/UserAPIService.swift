//
//  UserAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

protocol UserAPIServiceProtocol {
    func getSettingPage(completion: @escaping (NetworkResult<GetSettingPageResponseDTO>) -> Void)
    func getMyPage(completion: @escaping (NetworkResult<GetMyPageResponseDTO>) -> Void)
    func patchPushAlarm(requestBody: PatchPushAlarmRequestDTO,
                        completion: @escaping (NetworkResult<PatchPushAlarmResponseDTO>) -> Void)
    func getMainPage(completion: @escaping (NetworkResult<GetMainPageResponseDTO>) -> Void)
}

final class UserAPIService: BaseAPIService, UserAPIServiceProtocol {
    
    private let provider = MoyaProvider<UserTargetType>.init(session: Session(interceptor: APIInterceptor.shared), plugins: [MoyaPlugin()])

    func getSettingPage(completion: @escaping (NetworkResult<GetSettingPageResponseDTO>) -> Void) {
        provider.request(.getSettingPage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSettingPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetSettingPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func getMyPage(completion: @escaping (NetworkResult<GetMyPageResponseDTO>) -> Void) {
        provider.request(.getMyPage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMyPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMyPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func patchPushAlarm(requestBody: PatchPushAlarmRequestDTO, 
                        completion: @escaping (NetworkResult<PatchPushAlarmResponseDTO>) -> Void) {
        provider.request(.patchPushAlarm(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PatchPushAlarmResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PatchPushAlarmResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func getMainPage(completion: @escaping (NetworkResult<GetMainPageResponseDTO>) -> Void) {
        provider.request(.getMainPage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMainPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetMainPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}

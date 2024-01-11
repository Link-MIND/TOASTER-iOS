//
//  UserAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

protocol UserAPIServiceProtocol {
    func getSettingPage(completion: @escaping (NetworkResult<GetSettingPageResponseDTO>) -> ())
    func getMyPage(completion: @escaping (NetworkResult<GetMyPageResponseDTO>) -> ())
    func patchPushAlarm(requestBody: PatchPushAlarmRequestDTO,
                        completion: @escaping (NetworkResult<PatchPushAlarmResponseDTO>) -> ())
    func getMainPage(completion: @escaping (NetworkResult<GetMainPageResponseDTO>) -> ())
}

final class UserAPIService: BaseAPIService, UserAPIServiceProtocol {
    
    private let provider = MoyaProvider<UserTargetType>(plugins: [MoyaPlugin()])

    func getSettingPage(completion: @escaping (NetworkResult<GetSettingPageResponseDTO>) -> ()) {
        provider.request(.getSettingPage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetSettingPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func getMyPage(completion: @escaping (NetworkResult<GetMyPageResponseDTO>) -> ()) {
        provider.request(.getMyPage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMyPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func patchPushAlarm(requestBody: PatchPushAlarmRequestDTO, 
                        completion: @escaping (NetworkResult<PatchPushAlarmResponseDTO>) -> ()) {
        provider.request(.patchPushAlarm(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PatchPushAlarmResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func getMainPage(completion: @escaping (NetworkResult<GetMainPageResponseDTO>) -> ()) {
        provider.request(.getMainPage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetMainPageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
}

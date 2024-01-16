//
//  TimerAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

import Moya

protocol TimerAPIServiceProtocol {
    func getTimerMainpage(completion: @escaping (NetworkResult<GetTimerMainpageResponseDTO>) -> Void)
    func postCreateTimer(requestBody: PostCreateTimerRequestDTO,
                         completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func patchEditTimer(timerId: Int,
                        requestBody: PatchEditTimerRequestDTO,
                        completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func deleteTimer(timerId: Int,
                     completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func getDetailTimer(timerId: Int,
                        completion: @escaping (NetworkResult<GetDetailTimerResponseDTO>) -> Void)
    func patchEditTimerTitle(timerId: Int,
                             requestBody: PatchEditTimerTitleRequestDTO,
                             completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func patchEditAlarmTimer(timerId: Int,
                             completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
}

final class TimerAPIService: BaseAPIService, TimerAPIServiceProtocol {
    
    private let provider = MoyaProvider<TimerTargetType>.init(session: Session(interceptor: APIInterceptor.shared), plugins: [MoyaPlugin()])
    
    func getTimerMainpage(completion: @escaping (NetworkResult<GetTimerMainpageResponseDTO>) -> Void) {
        provider.request(.getTimerMainpage) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetTimerMainpageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetTimerMainpageResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func postCreateTimer(requestBody: PostCreateTimerRequestDTO,
                         completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.postCreateTimer(requestBody: requestBody)) { result in
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
    
    func patchEditTimer(timerId: Int,
                        requestBody: PatchEditTimerRequestDTO,
                        completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.patchEditTimer(timerId: timerId,
                                         requestBody: requestBody)) { result in
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
    
    func deleteTimer(timerId: Int,
                     completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.deleteTimer(timerId: timerId)) { result in
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
    
    func getDetailTimer(timerId: Int,
                        completion: @escaping (NetworkResult<GetDetailTimerResponseDTO>) -> Void) {
        provider.request(.getDetailTimer(timerId: timerId)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetDetailTimerResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetDetailTimerResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func patchEditTimerTitle(timerId: Int,
                             requestBody: PatchEditTimerTitleRequestDTO,
                             completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.patchEditTimerTitle(timerId: timerId,
                                              requestBody: requestBody)) { result in
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
    
    func patchEditAlarmTimer(timerId: Int,
                             completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.patchEditAlarmTimer(timerId: timerId)) { result in
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
}

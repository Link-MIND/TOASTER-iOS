//
//  TimerAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Combine
import Foundation

import Moya

protocol TimerAPIServiceProtocol {
    func getTimerMainpage(completion: @escaping (NetworkResult<GetTimerMainpageResponseDTO>) -> Void)
    
    func postCreateTimer(requestBody: PostCreateTimerRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func patchEditTimer(timerId: Int, requestBody: PatchEditTimerRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func deleteTimer(timerId: Int,
                     completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    
    func getDetailTimer(timerId: Int) -> AnyPublisher<GetDetailTimerResponseDTO, ToasterError>

    func patchEditTimerTitle(timerId: Int, requestBody: PatchEditTimerTitleRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>

    func patchEditAlarmTimer(timerId: Int,
                             completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
}

final class TimerAPIService: BaseAPIService<TimerTargetType>, TimerAPIServiceProtocol {
    
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
    
    func postCreateTimer(requestBody: PostCreateTimerRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .postCreateTimer(requestBody: requestBody)
        )
    }
    
    func patchEditTimer(timerId: Int, requestBody: PatchEditTimerRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .patchEditTimer(timerId: timerId, requestBody: requestBody)
        )
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
    
    func getDetailTimer(timerId: Int) -> AnyPublisher<GetDetailTimerResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getDetailTimer(timerId: timerId),
            responseType: GetDetailTimerResponseDTO.self
        )
    }
    
    func patchEditTimerTitle(timerId: Int, requestBody: PatchEditTimerTitleRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .patchEditTimerTitle(timerId: timerId, requestBody: requestBody)
        )
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

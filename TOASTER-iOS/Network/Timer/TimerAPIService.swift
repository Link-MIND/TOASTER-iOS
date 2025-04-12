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
    func getTimerMainpage() -> AnyPublisher<GetTimerMainpageResponseDTO, ToasterError>
    
    func postCreateTimer(requestBody: PostCreateTimerRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>

    func patchEditTimer(timerId: Int, requestBody: PatchEditTimerRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>

    func deleteTimer(timerId: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func getDetailTimer(timerId: Int) -> AnyPublisher<GetDetailTimerResponseDTO, ToasterError>
    
    func patchEditTimerTitle(timerId: Int, requestBody: PatchEditTimerTitleRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func patchEditAlarmTimer(timerId: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
}

final class TimerAPIService: BaseAPIService<TimerTargetType>, TimerAPIServiceProtocol {
    private let provider = MoyaProvider<TimerTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func getTimerMainpage() -> AnyPublisher<GetTimerMainpageResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getTimerMainpage,
            responseType: GetTimerMainpageResponseDTO.self
        )
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
    
    func deleteTimer(timerId: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .deleteTimer(timerId: timerId)
        )
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
    
    func patchEditAlarmTimer(timerId: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .patchEditAlarmTimer(timerId: timerId)
        )
    }
}

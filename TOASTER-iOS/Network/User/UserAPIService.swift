//
//  UserAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Combine
import Foundation

import Moya

protocol UserAPIServiceProtocol {
    func getSettingPage() -> AnyPublisher<GetSettingPageResponseDTO, ToasterError>
    
    func getMyPage() -> AnyPublisher<GetMyPageResponseDTO, ToasterError>
    
    func patchPushAlarm(requestBody: PatchPushAlarmRequestDTO) -> AnyPublisher<PatchPushAlarmResponseDTO, ToasterError>
    
    func getMainPage() -> AnyPublisher<GetMainPageResponseDTO, ToasterError>
}

final class UserAPIService: BaseAPIService<UserTargetType>, UserAPIServiceProtocol {
    private let provider = MoyaProvider<UserTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func getSettingPage() -> AnyPublisher<GetSettingPageResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getSettingPage,
            responseType: GetSettingPageResponseDTO.self
        )
    }
    
    func getMyPage() -> AnyPublisher<GetMyPageResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getMyPage,
            responseType: GetMyPageResponseDTO.self
        )
    }
    
    func patchPushAlarm(requestBody: PatchPushAlarmRequestDTO) -> AnyPublisher<PatchPushAlarmResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .patchPushAlarm(requestBody: requestBody),
            responseType: PatchPushAlarmResponseDTO.self
        )
    }
    
    func getMainPage() -> AnyPublisher<GetMainPageResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getMainPage,
            responseType: GetMainPageResponseDTO.self
        )
    }
}

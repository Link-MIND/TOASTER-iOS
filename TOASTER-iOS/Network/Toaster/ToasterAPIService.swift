//
//  ToasterAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Combine
import Foundation

import Moya

protocol ToasterAPIServiceProtocol {
    func postSaveLink(requestBody: PostSaveLinkRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func patchOpenLink(requestBody: PatchOpenLinkRequestDTO) -> AnyPublisher<PatchOpenLinkResponseDTO, ToasterError>

    func deleteLink(toastId: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func getWeeksLink() -> AnyPublisher<GetWeeksLinkResponseDTO, ToasterError>
    
    func patchEditLinkTitle(requestBody: PatchEditLinkTitleRequestDTO) -> AnyPublisher<PatchEditLinkTitleResponseDTO, ToasterError>

    func getRecentLink() -> AnyPublisher<GetRecentLinkResponseDTO, ToasterError>
    
    func patchChangeCategory(requestBody: PatchChangeCategoryRequestDTO) -> AnyPublisher<PatchChangeCategoryResponseDTO, ToasterError>
}

final class ToasterAPIService: BaseAPIService<ToasterTargetType>, ToasterAPIServiceProtocol {
    private let provider = MoyaProvider<ToasterTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func postSaveLink(requestBody: PostSaveLinkRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .postSaveLink(requestBody: requestBody)
        )
    }
    
    func patchOpenLink(requestBody: PatchOpenLinkRequestDTO) -> AnyPublisher<PatchOpenLinkResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .patchOpenLink(requestBody: requestBody),
            responseType: PatchOpenLinkResponseDTO.self
        )
    }
    
    func deleteLink(toastId: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .deleteLink(toastId: toastId)
        )
    }
    
    func getWeeksLink() -> AnyPublisher<GetWeeksLinkResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getWeeksLink,
            responseType: GetWeeksLinkResponseDTO.self
        )
    }
    
    func patchEditLinkTitle(requestBody: PatchEditLinkTitleRequestDTO) -> AnyPublisher<PatchEditLinkTitleResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .patchEditLinkTitle(requestBody: requestBody),
            responseType: PatchEditLinkTitleResponseDTO.self
        )
    }
    
    func getRecentLink() -> AnyPublisher<GetRecentLinkResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getRecentLink,
            responseType: GetRecentLinkResponseDTO.self
        )
    }
    
    func patchChangeCategory(requestBody: PatchChangeCategoryRequestDTO) -> AnyPublisher<PatchChangeCategoryResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .patchChangeCategory(requestBody: requestBody),
            responseType: PatchChangeCategoryResponseDTO.self
        )
    }
}

//
//  PopupAPIService.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/23/24.
//

import Combine
import Foundation

import Moya

protocol PopupAPIServiceProtocol {
    func getPopupInfo() -> AnyPublisher<GetPopupInfoResponseDTO, ToasterError>
    
    func patchEditPopupHidden(requestBody: PatchPopupHiddenRequestDTO) -> AnyPublisher<PatchPopupHiddenResponseDTO, ToasterError>
}

final class PopupAPIService: BaseAPIService<PopupTargetType>, PopupAPIServiceProtocol {
    private let provider = MoyaProvider<PopupTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func getPopupInfo() -> AnyPublisher<GetPopupInfoResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getPopupInfo,
            responseType: GetPopupInfoResponseDTO.self
        )
    }
    
    func patchEditPopupHidden(requestBody: PatchPopupHiddenRequestDTO) -> AnyPublisher<PatchPopupHiddenResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .patchEditPopupHidden(requestBody: requestBody),
            responseType: PatchPopupHiddenResponseDTO.self
        )
    }}

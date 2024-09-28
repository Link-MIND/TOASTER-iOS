//
//  PopupAPIService.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/23/24.
//

import Foundation

import Moya

protocol PopupAPIServiceProtocol {
    func getPopupInfo(completion: @escaping (NetworkResult<GetPopupInfoResponseDTO>) -> Void)
    func patchEditPopupHidden(requestBody: PatchPopupHiddenRequestDTO,
                              completion: @escaping (NetworkResult<PatchPopupHiddenResponseDTO>) -> Void)
}

final class PopupAPIService: BaseAPIService, PopupAPIServiceProtocol {
    private let provider = MoyaProvider<PopupTargetType>.init(session: Session(interceptor: APIInterceptor.shared), plugins: [MoyaPlugin()])

    func getPopupInfo(completion: @escaping (NetworkResult<GetPopupInfoResponseDTO>) -> Void) {
        provider.request(.getPopupInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetPopupInfoResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<GetPopupInfoResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    func patchEditPopupHidden(requestBody: PatchPopupHiddenRequestDTO,
                              completion: @escaping (NetworkResult<PatchPopupHiddenResponseDTO>) -> Void) {
        provider.request(.patchEditPopupHidden(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PatchPopupHiddenResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PatchPopupHiddenResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}

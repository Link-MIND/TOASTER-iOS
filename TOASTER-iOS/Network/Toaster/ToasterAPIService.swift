//
//  ToasterAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

import Moya

protocol ToasterAPIServiceProtocol {
    func postSaveLink(requestBody: PostSaveLinkRequestDTO,
                      completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func patchOpenLink(requestBody: PostSaveLinkRequestDTO,
                       completion: @escaping (NetworkResult<PatchOpenLinkResponseDTO>) -> Void)
    func deleteLink(toastId: Int,
                    completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func getWeeksLink(completion: @escaping (NetworkResult<GetWeeksLinkResponseDTO>) -> Void)
}

final class ToasterAPIService: BaseAPIService, ToasterAPIServiceProtocol {
    
    private let provider = MoyaProvider<ToasterTargetType>(plugins: [MoyaPlugin()])

    func postSaveLink(requestBody: PostSaveLinkRequestDTO, 
                      completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.postSaveLink(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NoneDataResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func patchOpenLink(requestBody: PostSaveLinkRequestDTO, 
                       completion: @escaping (NetworkResult<PatchOpenLinkResponseDTO>) -> Void) {
        provider.request(.patchOpenLink(requestBody: requestBody)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PatchOpenLinkResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func deleteLink(toastId: Int,
                    completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.deleteLink(toastId: toastId)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NoneDataResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func getWeeksLink(completion: @escaping (NetworkResult<GetWeeksLinkResponseDTO>) -> Void) {
        provider.request(.getWeeksLink) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetWeeksLinkResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
}

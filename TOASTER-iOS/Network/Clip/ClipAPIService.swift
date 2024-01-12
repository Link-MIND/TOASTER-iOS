//
//  ClipAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

import Moya

protocol ClipAPIServiceProtocol {
    func postAddCategory(requestBody: PostAddCategoryRequestDTO,
                         completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func getDetailCategory(categoryID: Int,
                           filter: DetailCategoryFilter,
                           completion: @escaping (NetworkResult<GetDetailCategoryResponseDTO>) -> Void)
    func getDetailAllCategory(filter: DetailCategoryFilter,
                              ompletion: @escaping (NetworkResult<GetDetailAllCategoryResponseDTO>) -> Void)
    func deleteCategory(requestBody: DeleteCategoryRequestDTO,
                        completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func patchEditCategory(requestBody: PatchPushAlarmRequestDTO,
                           completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void)
    func getAllCategory(completion: @escaping (NetworkResult<GetAllCategoryResponseDTO>) -> Void)
    func getCheckCategory(categoryTitle: String,
                          completion: @escaping (NetworkResult<GetCheckCategoryResponseDTO>) -> Void)
}

final class ClipAPIService: BaseAPIService, ClipAPIServiceProtocol {
    
    private let provider = MoyaProvider<ClipTargetType>(plugins: [MoyaPlugin()])

    func postAddCategory(requestBody: PostAddCategoryRequestDTO,
                         completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.postAddCategory(requestBody: requestBody)) { result in
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
    
    func getDetailCategory(categoryID: Int, 
                           filter: DetailCategoryFilter,
                           completion: @escaping (NetworkResult<GetDetailCategoryResponseDTO>) -> Void) {
        provider.request(.getDetailCategory(categoryID: categoryID,
                                            filter: filter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetDetailCategoryResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func getDetailAllCategory(filter: DetailCategoryFilter,
                              ompletion completion: @escaping (NetworkResult<GetDetailAllCategoryResponseDTO>) -> Void) {
        provider.request(.getDetailCategory(categoryID: 0,
                                            filter: filter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetDetailAllCategoryResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func deleteCategory(requestBody: DeleteCategoryRequestDTO, 
                        completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.deleteCategory(requestBody: requestBody)) { result in
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
    
    func patchEditCategory(requestBody: PatchPushAlarmRequestDTO, 
                           completion: @escaping (NetworkResult<NoneDataResponseDTO>) -> Void) {
        provider.request(.patchEditCategory(requestBody: requestBody)) { result in
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
    
    func getAllCategory(completion: @escaping (NetworkResult<GetAllCategoryResponseDTO>) -> Void) {
        provider.request(.getAllCategory) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetAllCategoryResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
    
    func getCheckCategory(categoryTitle: String, 
                          completion: @escaping (NetworkResult<GetCheckCategoryResponseDTO>) -> Void) {
        provider.request(.getCheckCategory(categoryTitle: categoryTitle)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetCheckCategoryResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
}

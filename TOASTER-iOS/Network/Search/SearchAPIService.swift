//
//  SearchAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

import Moya

protocol SearchAPIServiceProtocol {
    func getMainPageSearch(searchText: String,
                           completion: @escaping (NetworkResult<GetMainPageResponseDTO>) -> Void)
    func getRecommendSite(completion: @escaping (NetworkResult<GetRecommendSiteResponseDTO>) -> Void)
}

final class SearchAPIService: BaseAPIService, SearchAPIServiceProtocol {
    
    private let provider = MoyaProvider<SearchTargetType>(plugins: [MoyaPlugin()])

    func getMainPageSearch(searchText: String, 
                           completion: @escaping (NetworkResult<GetMainPageResponseDTO>) -> Void) {
        provider.request(.getMainPageSearch(searchText: searchText)) { result in
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
    
    func getRecommendSite(completion: @escaping (NetworkResult<GetRecommendSiteResponseDTO>) -> Void) {
        provider.request(.getRecommendSite) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<GetRecommendSiteResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                print(error)
                completion(.networkFail)
            }
        }
    }
}

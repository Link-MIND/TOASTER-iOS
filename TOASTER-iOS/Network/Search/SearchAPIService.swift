//
//  SearchAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Combine
import Foundation

import Moya

protocol SearchAPIServiceProtocol {
    func getMainPageSearch(searchText: String) -> AnyPublisher<GetMainPageSearchResponseDTO, ToasterError>

    func getRecommendSite() -> AnyPublisher<GetRecommendSiteResponseDTO, ToasterError>
}

final class SearchAPIService: BaseAPIService<SearchTargetType>, SearchAPIServiceProtocol {
    private let provider = MoyaProvider<SearchTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func getMainPageSearch(searchText: String) -> AnyPublisher<GetMainPageSearchResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getMainPageSearch(searchText: searchText),
            responseType: GetMainPageSearchResponseDTO.self
        )
    }
    
    func getRecommendSite() -> AnyPublisher<GetRecommendSiteResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getRecommendSite,
            responseType: GetRecommendSiteResponseDTO.self
        )
    }
}

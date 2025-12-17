//
//  ClipAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Combine
import Foundation

import Moya

protocol ClipAPIServiceProtocol {
    func postAddCategory(requestBody: PostAddCategoryRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func getDetailCategory(categoryID: Int, filter: DetailCategoryFilter) -> AnyPublisher<GetDetailCategoryResponseDTO, ToasterError>
    
    func getDetailAllCategory(filter: DetailCategoryFilter) -> AnyPublisher<GetDetailCategoryResponseDTO, ToasterError>

    func deleteCategory(deleteCategoryDto: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func patchEditPriorityCategory(requestBody: PatchEditPriorityCategoryRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>

    func patchEditNameCategory(requestBody: PatchEditNameCategoryRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError>
    
    func getAllCategory() -> AnyPublisher<GetAllCategoryResponseDTO, ToasterError>
    
    func getCheckCategory(categoryTitle: String) -> AnyPublisher<GetCheckCategoryResponseDTO, ToasterError>
}

final class ClipAPIService: BaseAPIService<ClipTargetType>, ClipAPIServiceProtocol {
    private let provider = MoyaProvider<ClipTargetType>(
        session: Session(interceptor: APIInterceptor.shared),
        plugins: [MoyaPlugin()]
    )
    
    func postAddCategory(requestBody: PostAddCategoryRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .postAddCategory(requestBody: requestBody)
        )
    }
    
    func getDetailCategory(categoryID: Int, filter: DetailCategoryFilter) -> AnyPublisher<GetDetailCategoryResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getDetailCategory(categoryID: categoryID, filter: filter),
            responseType: GetDetailCategoryResponseDTO.self
        )
    }
    
    func getDetailAllCategory(filter: DetailCategoryFilter) -> AnyPublisher<GetDetailCategoryResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getDetailCategory(categoryID: 0, filter: filter),
            responseType: GetDetailCategoryResponseDTO.self
        )
    }
    
    func deleteCategory(deleteCategoryDto: Int) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .deleteCategory(deleteCategoryDto: deleteCategoryDto)
        )
    }
    
    func patchEditPriorityCategory(requestBody: PatchEditPriorityCategoryRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .patchEditPriorityCategory(requestBody: requestBody)
        )
    }
    
    func patchEditNameCategory(requestBody: PatchEditNameCategoryRequestDTO) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return requestWithoutDecodeWithCombine(
            provider: provider,
            target: .patchEditNameCategory(requestBody: requestBody)
        )
    }
    
    func getAllCategory() -> AnyPublisher<GetAllCategoryResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getAllCategory,
            responseType: GetAllCategoryResponseDTO.self
        )
    }
    
    func getCheckCategory(categoryTitle: String) -> AnyPublisher<GetCheckCategoryResponseDTO, ToasterError> {
        return requestWithCombine(
            provider: provider,
            target: .getCheckCategory(categoryTitle: categoryTitle),
            responseType: GetCheckCategoryResponseDTO.self
        )
    }
}

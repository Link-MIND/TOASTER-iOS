//
//  EditClipViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 2/8/24.
//

import Combine
import UIKit

final class EditClipViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    
    private(set) var cellIndex: Int = 0
    var clipList: ClipModel = ClipModel(allClipToastCount: 0, clips: [])
    
    // MARK: - Input State
    
    struct Input {
        let requestClipList: Driver<Void>
        let deleteClipButtonTapped: Driver<Int>
        let clipNameChanged: Driver<String>
        let changeClipNameButtonTapped: Driver<ClipNameEditModel>
        let clipOrderedChanged: Driver<ClipPriorityEditModel>
    }
    
    // MARK: - Output State
    
    struct Output {
        let needToReload = PassthroughSubject<Void, Never>()
        let deleteClipResult = PassthroughSubject<Void, Never>()
        let duplicateClipName = PassthroughSubject<Bool, Never>()
        let changeClipNameResult = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestClipList
            .networkFlatMap(self) { context, _ in
                context.getAllCategoryAPI()
            }
            .sink { [weak self] clipList in
                self?.clipList = clipList
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.deleteClipButtonTapped
            .networkFlatMap(self) { context, clipID in
                context.deleteCategoryAPI(deleteCategoryDto: clipID)
            }
            .sink { _ in
                output.deleteClipResult.send()
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.clipNameChanged
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .networkFlatMap(self) { context, clipTitle in
                context.getCheckCategoryAPI(categoryTitle: clipTitle)
            }
            .sink { isDuplicated in
                output.duplicateClipName.send(isDuplicated)
            }.store(in: cancelBag)
        
        input.changeClipNameButtonTapped
            .networkFlatMap(self) { context, model in
                context.patchEditNameCategoryAPI(requestBody: model)
            }
            .sink { isSuccess in
                output.changeClipNameResult.send(isSuccess)
            }.store(in: cancelBag)
        
        input.clipOrderedChanged
            .networkFlatMap(self) { context, model in
                context.patchEditPriorityCategoryAPI(requestBody: model)
            }
            .sink { _ in
                output.needToReload.send()
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Extension

extension EditClipViewModel {
    func setupCellIndex(_ index: Int) {
        cellIndex = index
    }
}

// MARK: - Network

private extension EditClipViewModel {
    func getAllCategoryAPI() -> AnyPublisher<ClipModel, ToasterError> {
        return NetworkService.shared.clipService.getAllCategory()
            .map { response in
                let allClipToastCount = response.data.toastNumberInEntire
                let clips = response.data.categories.map {
                    AllClipModel(id: $0.categoryId,
                                 title: $0.categoryTitle,
                                 toastCount: $0.toastNum)
                }
                return ClipModel(allClipToastCount: allClipToastCount, clips: clips)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteCategoryAPI(deleteCategoryDto: Int) -> AnyPublisher<Void, ToasterError> {
        return NetworkService.shared.clipService.deleteCategory(deleteCategoryDto: deleteCategoryDto)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func patchEditPriorityCategoryAPI(requestBody: ClipPriorityEditModel) -> AnyPublisher<Void, ToasterError> {
        let dto = PatchEditPriorityCategoryRequestDTO(categoryId: requestBody.id, newPriority: requestBody.priority)
        return NetworkService.shared.clipService.patchEditPriorityCategory(requestBody: dto)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func patchEditNameCategoryAPI(requestBody: ClipNameEditModel) -> AnyPublisher<Bool, ToasterError> {
        let dto = PatchEditNameCategoryRequestDTO(categoryId: requestBody.id, newTitle: requestBody.title)
        return NetworkService.shared.clipService.patchEditNameCategory(requestBody: dto)
            .map { _ in true }
            .eraseToAnyPublisher()
    }

    func getCheckCategoryAPI(categoryTitle: String) -> AnyPublisher<Bool, ToasterError> {
        return NetworkService.shared.clipService.getCheckCategory(categoryTitle: categoryTitle)
            .map { $0.data.isDupicated && categoryTitle.count < 16 }
            .eraseToAnyPublisher()
    }
}

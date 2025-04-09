//
//  ClipViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 2/7/24.
//

import Combine
import UIKit

final class ClipViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    var clipList: ClipModel = ClipModel(allClipToastCount: 0, clips: [])
    
    private let clipService: ClipAPIServiceProtocol
    
    init(clipService: ClipAPIServiceProtocol) {
        self.clipService = clipService
    }
    
    // MARK: - Input State
    
    struct Input {
        let requestClipList: Driver<Void>
        let clipNameChanged: Driver<String>
        let addClipButtonTapped: Driver<String>
    }
    
    // MARK: - Output State
    
    struct Output {
        let needToReload = PassthroughSubject<Void, Never>()
        let addClipResult = PassthroughSubject<Bool, Never>()
        let duplicateClipName = PassthroughSubject<Bool, Never>()
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
        
        input.clipNameChanged
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .networkFlatMap(self) { context, clipTitle in
                context.getCheckCategoryAPI(categoryTitle: clipTitle)
            }
            .sink { isDuplicate in
                output.duplicateClipName.send(isDuplicate)
            }.store(in: cancelBag)
        
        input.addClipButtonTapped
            .networkFlatMap(self) { context, clipTitle in
                context.postAddCategoryAPI(requestBody: clipTitle)
            }
            .sink { isSuccess in
                output.addClipResult.send(isSuccess)
                if isSuccess {
                    output.needToReload.send()
                }
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Network

private extension ClipViewModel {
    func getAllCategoryAPI() -> AnyPublisher<ClipModel, Never> {
        return clipService.getAllCategory()
            .map { response in
                let totalCount = response.data.toastNumberInEntire
                let clips = response.data.categories.map {
                    AllClipModel(
                        id: $0.categoryId,
                        title: $0.categoryTitle,
                        toastCount: $0.toastNum
                    )
                }
                return ClipModel(allClipToastCount: totalCount, clips: clips)
            }
            .catch { _ in Just(ClipModel(allClipToastCount: 0, clips: [])) }
            .eraseToAnyPublisher()
    }
    
    func getCheckCategoryAPI(categoryTitle: String) -> AnyPublisher<Bool, Never> {
        return clipService.getCheckCategory(categoryTitle: categoryTitle)
            .map { $0.data.isDupicated && categoryTitle.count < 16 }
            .catch { _ in Just(false) }
            .eraseToAnyPublisher()
    }

    func postAddCategoryAPI(requestBody: String) -> AnyPublisher<Bool, Never> {
        let request = PostAddCategoryRequestDTO(categoryTitle: requestBody)
        return clipService.postAddCategory(requestBody: request)
            .map { _ in true }
            .catch { _ in Just(false) }
            .eraseToAnyPublisher()
    }
}

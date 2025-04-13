//
//  SelectClipViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/02/27.
//

import Combine
import UIKit

final class SelectClipViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    var selectedClip: [RemindClipModel] = []
    
    // MARK: - Input State
    
    struct Input {
        let requestClipList: Driver<Void>
        let clipNameChanged: Driver<String>
        let addClipButtonTapped: Driver<String>
        let completeButtonTapped: Driver<(String, Int?)>
    }
    
    // MARK: - Output State
    
    struct Output {
        let needToReload = PassthroughSubject<Void, Never>()
        let duplicateClipName = PassthroughSubject<Bool, Never>()
        let addClipResult = PassthroughSubject<Bool, Never>()
        let saveLinkResult = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestClipList
            .networkFlatMap(self) { context, _ in
                context.fetchClipData()
            }
            .sink { [weak self] clipDataList in
                self?.selectedClip = clipDataList
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
        
        input.completeButtonTapped
            .networkFlatMap(self) { context, body in
                context.postSaveLink(url: body.0, category: body.1)
            }
            .sink { result in
                output.saveLinkResult.send(result)
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Network

private extension SelectClipViewModel {
    func postSaveLink(url: String, category: Int?) -> AnyPublisher<Bool, ToasterError> {
        let request = PostSaveLinkRequestDTO(linkUrl: url, categoryId: category)

        return NetworkService.shared.toastService.postSaveLink(requestBody: request)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func fetchClipData() -> AnyPublisher<[RemindClipModel], ToasterError> {
        return NetworkService.shared.clipService.getAllCategory()
            .map { response in
                var clipDataList: [RemindClipModel] = [
                    RemindClipModel(
                        id: nil,
                        title: "전체 클립",
                        clipCount: response.data.toastNumberInEntire
                    )
                ]
                response.data.categories.forEach {
                    let clipData = RemindClipModel(
                        id: $0.categoryId,
                        title: $0.categoryTitle,
                        clipCount: $0.toastNum
                    )
                    clipDataList.append(clipData)
                }
                return clipDataList
            }
            .eraseToAnyPublisher()
    }
    
    func getCheckCategoryAPI(categoryTitle: String) -> AnyPublisher<Bool, ToasterError> {
        return NetworkService.shared.clipService.getCheckCategory(categoryTitle: categoryTitle)
            .map { $0.data.isDupicated && categoryTitle.count < 16 }
            .eraseToAnyPublisher()
    }
    
    func postAddCategoryAPI(requestBody: String) -> AnyPublisher<Bool, ToasterError> {
        let dto = PostAddCategoryRequestDTO(categoryTitle: requestBody)
        return NetworkService.shared.clipService.postAddCategory(requestBody: dto)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
}

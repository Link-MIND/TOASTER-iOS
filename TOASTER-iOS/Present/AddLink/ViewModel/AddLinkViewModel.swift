//
//  AddLinkViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 9/19/24.
//

import Combine
import UIKit

final class AddLinkViewModel: ViewModelType {
        
    var selectedClip: [RemindClipModel] = []
    let embedLinkText = PassthroughSubject<String, Never>()
    
    struct Input {
        let embedLinkText: AnyPublisher<String, Never>
        let clearButtonTapped: AnyPublisher<Void, Never>
        let requestClipList: Driver<Void>
        let clipNameChanged: Driver<String>
        let addClipButtonTapped: Driver<String>
        let completeButtonTapped: Driver<(String, Int?)>
    }
    
    struct Output {
        let isClearButtonHidden = PassthroughSubject<Bool, Never>()
        let isNextButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        let textFieldBorderColor = PassthroughSubject<UIColor, Never>()
        let linkEffectivenessMessage = PassthroughSubject<String?, Never>()
        let needToReload = PassthroughSubject<Void, Never>()
        let duplicateClipName = PassthroughSubject<Bool, Never>()
        let addClipResult = PassthroughSubject<Bool, Never>()
        let saveLinkResult = PassthroughSubject<Bool, Never>()
        let navigateToLogin = PassthroughSubject<Void, Never>()
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let inputText = input.embedLinkText
            .merge(with: input.clearButtonTapped.map { "" })
            .eraseToAnyPublisher()
        
        inputText
            .map { $0.isEmpty }
            .sink { isHidden in
                output.isClearButtonHidden.send(isHidden)
            }
            .store(in: cancelBag)
        
        let isValid = inputText
            .map { self.isValidURL($0) }
            .share()
            .eraseToAnyPublisher()
        
        isValid
            .combineLatest(inputText.map { !$0.isEmpty })
            .map { $0 && $1 }
            .sink { isEnabled in
                output.isNextButtonEnabled.send(isEnabled)
            }
            .store(in: cancelBag)
        
        input.embedLinkText
            .map { $0.isEmpty ? "링크를 입력해주세요" : (self.isValidURL($0) ? nil : "유효하지 않은 형식의 링크입니다. " ) }
            .sink { message in
                output.linkEffectivenessMessage.send(message)
            }
            .store(in: cancelBag)
        
        input.requestClipList
            .networkFlatMap(self, { context, _ in
                context.fetchClipData()
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] clipDataList in
                self?.selectedClip = clipDataList
                output.needToReload.send()
            }.store(in: cancelBag)
        
        input.clipNameChanged
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .networkFlatMap(self, { context, clipTitle in
                context.getCheckCategoryAPI(categoryTitle: clipTitle)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { isDuplicate in
                output.duplicateClipName.send(isDuplicate)
            }.store(in: cancelBag)
        
        input.addClipButtonTapped
            .networkFlatMap(self, { context, clipTitle in
                context.postAddCategoryAPI(requestBody: clipTitle)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { isSuccess in
                output.addClipResult.send(isSuccess)
                if isSuccess {
                    output.needToReload.send()
                }
            }.store(in: cancelBag)
        
        input.completeButtonTapped
            .networkFlatMap(self, { context, body in
                context.postSaveLink(url: body.0, category: body.1)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { result in
                output.saveLinkResult.send(result)
            }.store(in: cancelBag)
        
        return output
    }
}

private extension AddLinkViewModel {
    func isValidURL(_ urlString: String) -> Bool {
        if (urlString.prefix(8) == "https://") || (urlString.prefix(7) == "http://") {
            return true
        } else {
            return false
        }
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

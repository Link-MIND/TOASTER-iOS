//
//  DetailClipViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 2/8/24.
//

import Combine
import UIKit

final class DetailClipViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    
    private(set) var toastList: DetailClipModel = DetailClipModel(allToastCount: 0, toastList: [])
    
    private(set) var currentToastId: Int = 0
    private(set) var currentCategoryId: Int = 0
    private(set) var currentCategoryName: String = ""
    private(set) var segmentIndex: Int = 0
    private(set) var linkTitle: String = ""
    
    private(set) var botomHeigth: CGFloat = 0
    private(set) var collectionViewHeight: CGFloat = 0
    
    // MARK: - Input State
    
    struct Input {
        let requestToast: Driver<Bool>
        let changeSegmentIndex: Driver<Int>
        let editToastTitleButtonTap: Driver<(Int, String)>
        let changeClipButtonTap: Driver<Void>
        let selectedClip: Driver<Int>
        let changeClipCompleteButtonTap: Driver<Void>
        let deleteToastButtonTap: Driver<Int>
    }
    
    // MARK: - Output State
    
    struct Output {
        let loadToToastList = PassthroughSubject<Bool, Never>()
        let toastNameChanged = PassthroughSubject<Bool, Never>()
        let loadToClipData = PassthroughSubject<[SelectClipModel]?, Never>()
        let isCompleteButtonEnable = PassthroughSubject<Bool, Never>()
        let changeCategoryResult = PassthroughSubject<Bool, Never>()
        let deleteToastComplete = PassthroughSubject<Void, Never>()
        let navigateToLogin = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestToast
            .networkFlatMap(self, { context, isAll in
                if isAll {
                    context.getDetailAllCategoryAPI(filter: .all)
                } else {
                    context.getDetailCategoryAPI(categoryID: self.currentCategoryId, filter: .all)
                }
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] toasts in
                self?.toastList = toasts
                output.loadToToastList.send(!toasts.toastList.isEmpty)
            }.store(in: cancelBag)
        
        input.changeSegmentIndex
            .networkFlatMap(self, { context, index in
                if self.currentCategoryId == 0 {
                    switch index {
                    case 0:
                        context.getDetailAllCategoryAPI(filter: .all)
                    case 1:
                        context.getDetailAllCategoryAPI(filter: .read)
                    default:
                        context.getDetailAllCategoryAPI(filter: .unread)
                    }
                } else {
                    switch index {
                    case 0:
                        context.getDetailCategoryAPI(categoryID: self.currentCategoryId, filter: .all)
                    case 1:
                        context.getDetailCategoryAPI(categoryID: self.currentCategoryId, filter: .read)
                    default:
                        context.getDetailCategoryAPI(categoryID: self.currentCategoryId, filter: .unread)
                    }
                }
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] toasts in
                self?.toastList = toasts
                output.loadToToastList.send(!toasts.toastList.isEmpty)
            }.store(in: cancelBag)
        
        input.editToastTitleButtonTap
            .networkFlatMap(self, { context, toast in
                context.patchEditLinkTitleAPI(toastId: toast.0, title: toast.1)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] isSuccess in
                output.toastNameChanged.send(isSuccess)
                output.loadToToastList.send(self?.currentCategoryId == 0)
            }.store(in: cancelBag)
        
        input.changeClipButtonTap
            .networkFlatMap(self, { context, _ in
                context.getAllCategoryAPI()
                    .map { [weak self] result -> [SelectClipModel]? in
                        guard let self = self else { return [] }
                        if result.count < 2 { return nil }  // 2개 이하일 경우 nil 반환
                        let sortedResult = self.sortCurrentCategoryToTop(result)
                        self.collectionViewHeight = self.calculateCollectionViewHeight(numberOfItems: sortedResult.count)
                        return sortedResult
                    }
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { model in
                output.loadToClipData.send(model)
            }.store(in: cancelBag)
        
        Publishers.Merge(
            input.changeClipButtonTap.map { false },
            input.selectedClip.map { _ in true }
        )
        .sink { isEnabled in
            output.isCompleteButtonEnable.send(isEnabled)
        }.store(in: cancelBag)
        
        input.changeClipCompleteButtonTap
            .zip(input.selectedClip) { _, selectedClip in
                return selectedClip
            }
            .networkFlatMap(self, { context, selectClip in
                context.patchChangeCategory(categoryId: selectClip)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { result in
                output.changeCategoryResult.send(result)
            }.store(in: cancelBag)
        
        input.deleteToastButtonTap
            .networkFlatMap(self, { context, toastId in
                context.deleteLinkAPI(toastId: toastId)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] _ in
                output.loadToToastList.send(self?.currentCategoryId == 0)
                output.deleteToastComplete.send()
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Extension Methods

extension DetailClipViewModel {
    func setupCategory(_ id: Int) {
        currentCategoryId = id
    }
    
    func setupCategoryName(_ name: String) {
        currentCategoryName = name
    }
    
    func setupToastId(_ id: Int) {
        currentToastId = id
    }
}

// MARK: - private Extensions

private extension DetailClipViewModel {
    
    /// 현재 카테고리를 최상단에 위치하도록 정렬하는 메서드
    func sortCurrentCategoryToTop(_ clipDataList: [SelectClipModel]) -> [SelectClipModel] {
        guard let currentCategoryIndex = clipDataList.firstIndex(where: { $0.id == currentCategoryId }) else {
            return clipDataList
        }
        
        var tempClipDataList = clipDataList
        let currentCategoryData = tempClipDataList.remove(at: currentCategoryIndex)
        tempClipDataList.insert(currentCategoryData, at: 0)
        
        calculateBottomSheetHeight(clipDataList.count)
        
        return tempClipDataList
    }
    
    func calculateBottomSheetHeight(_ count: Int) {
        botomHeigth = CGFloat(count * 54 + 184 + 3)
    }
    
    func calculateCollectionViewHeight(numberOfItems: Int) -> CGFloat {
        let cellHeight: CGFloat = 54
        let lineSpacing: CGFloat = 1
        
        // 마지막 셀 다음에는 간격이 없으므로 (numberOfItems - 1)
        let totalHeight = (cellHeight * CGFloat(numberOfItems)) + (lineSpacing * CGFloat(numberOfItems - 1))
        print("높이:", totalHeight)
        return totalHeight
    }
}

// MARK: - Network

private extension DetailClipViewModel {
    func getDetailAllCategoryAPI(filter: DetailCategoryFilter) -> AnyPublisher<DetailClipModel, ToasterError> {
        return NetworkService.shared.clipService.getDetailAllCategory(filter: filter)
            .map { response in
                let allToastCount = response.data.allToastNum
                let toasts = response.data.toastListDto.map {
                    ToastListModel(
                        id: $0.toastId,
                        title: $0.toastTitle,
                        url: $0.linkUrl,
                        isRead: $0.isRead,
                        clipTitle: $0.categoryTitle,
                        imageURL: $0.thumbnailUrl
                    )
                }
                return DetailClipModel(allToastCount: allToastCount, toastList: toasts)
            }
            .eraseToAnyPublisher()
    }
    
    func getDetailCategoryAPI(
        categoryID: Int,
        filter: DetailCategoryFilter
    ) -> AnyPublisher<DetailClipModel, ToasterError> {
        return NetworkService.shared.clipService.getDetailCategory(categoryID: categoryID, filter: filter)
            .map { response in
                let allToastCount = response.data.allToastNum
                let toasts = response.data.toastListDto.map {
                    ToastListModel(
                        id: $0.toastId,
                        title: $0.toastTitle,
                        url: $0.linkUrl,
                        isRead: $0.isRead,
                        clipTitle: $0.categoryTitle,
                        imageURL: $0.thumbnailUrl
                    )
                }
                return DetailClipModel(allToastCount: allToastCount, toastList: toasts)
            }
            .eraseToAnyPublisher()
    }
    
    func patchEditLinkTitleAPI(toastId: Int, title: String) -> AnyPublisher<Bool, ToasterError> {
        return NetworkService.shared.toastService.patchEditLinkTitle(
            requestBody: PatchEditLinkTitleRequestDTO(
                toastId: toastId,
                title: title
            )
        )
        .map { _ in true }
        .eraseToAnyPublisher()
    }
    
    func deleteLinkAPI(toastId: Int) -> AnyPublisher<Void, ToasterError> {
        return NetworkService.shared.toastService.deleteLink(toastId: toastId)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    func getAllCategoryAPI() -> AnyPublisher<[SelectClipModel], ToasterError> {
        return NetworkService.shared.clipService.getAllCategory()
            .map { response in
                let clipDataList = response.data.categories.map { category in
                    SelectClipModel(
                        id: category.categoryId,
                        title: category.categoryTitle,
                        clipCount: category.toastNum
                    )
                }
                return clipDataList
            }
            .eraseToAnyPublisher()
    }
    
    func patchChangeCategory(categoryId: Int) -> AnyPublisher<Bool, ToasterError> {
        let requestDTO = PatchChangeCategoryRequestDTO(toastId: currentToastId, categoryId: categoryId)
        
        return NetworkService.shared.toastService.patchChangeCategory(requestBody: requestDTO)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
}

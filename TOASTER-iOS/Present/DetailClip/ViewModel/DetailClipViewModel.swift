//
//  DetailClipViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 2/8/24.
//

import Foundation

final class DetailClipViewModel: NSObject {
    
    // MARK: - Properties
    
    typealias DataChangeAction = (Bool) -> Void
    private var dataChangeAction: DataChangeAction?
    
    typealias NormalChangeAction = () -> Void
    private var unAuthorizedAction: NormalChangeAction?
    
    // MARK: - Data
    
    var toastId: Int = 0
    var categoryId: Int = 0
    var categoryName: String = ""
    var segmentIndex: Int = 0
    
    var toastList: DetailClipModel = DetailClipModel(allToastCount: 0, toastList: []) {
        didSet {
            dataChangeAction?(!toastList.toastList.isEmpty)
        }
    }
}

// MARK: - Extensions

extension DetailClipViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction,
                               forUnAuthorizedAction: @escaping NormalChangeAction) {
        dataChangeAction = changeAction
        unAuthorizedAction = forUnAuthorizedAction
    }
    
    func getViewModelProperty(dataType: DetailClipPropertyType) -> Any {
        switch dataType {
        case .toastId:
            return toastId
        case .categoryId:
            return categoryId
        case .categoryName:
            return categoryName
        case .segmentIndex:
            return segmentIndex
        }
    }
    
    func getDetailAllCategoryAPI(filter: DetailCategoryFilter) {
        NetworkService.shared.clipService.getDetailAllCategory(filter: filter) { result in
            switch result {
            case .success(let response):
                let allToastCount = response?.data.allToastNum
                var toasts = [ToastListModel]()
                response?.data.toastListDto.forEach {
                    toasts.append(ToastListModel(id: $0.toastId,
                                                 title: $0.toastTitle,
                                                 url: $0.linkUrl,
                                                 isRead: $0.isRead,
                                                 clipTitle: $0.categoryTitle,
                                                 imageURL: $0.thumbnailUrl))
                }
                self.toastList = DetailClipModel(allToastCount: allToastCount ?? 0,
                                                 toastList: toasts)
            case .unAuthorized, .networkFail, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
    
    func getDetailCategoryAPI(categoryID: Int, filter: DetailCategoryFilter) {
        NetworkService.shared.clipService.getDetailCategory(categoryID: categoryID, filter: filter) { result in
            switch result {
            case .success(let response):
                let allToastCount = response?.data.allToastNum
                var toasts = [ToastListModel]()
                response?.data.toastListDto.forEach {
                    toasts.append(ToastListModel(id: $0.toastId,
                                                 title: $0.toastTitle,
                                                 url: $0.linkUrl,
                                                 isRead: $0.isRead,
                                                 clipTitle: $0.categoryTitle,
                                                 imageURL: $0.thumbnailUrl))
                }
                self.toastList = DetailClipModel(allToastCount: allToastCount ?? 0,
                                                 toastList: toasts)
            case .unAuthorized, .networkFail, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
    
    func deleteLinkAPI(toastId: Int) {
        NetworkService.shared.toastService.deleteLink(toastId: toastId) { result in
            switch result {
            case .success:
                if self.categoryId == 0 {
                    switch self.segmentIndex {
                    case 0: self.getDetailAllCategoryAPI(filter: .all)
                    case 1: self.getDetailAllCategoryAPI(filter: .read)
                    default: self.getDetailAllCategoryAPI(filter: .unread)
                    }
                } else {
                    switch self.segmentIndex {
                    case 0: self.getDetailCategoryAPI(categoryID: self.categoryId, filter: .all)
                    case 1: self.getDetailCategoryAPI(categoryID: self.categoryId, filter: .read)
                    default: self.getDetailCategoryAPI(categoryID: self.categoryId, filter: .unread)
                    }
                }
            case .unAuthorized, .networkFail, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
}

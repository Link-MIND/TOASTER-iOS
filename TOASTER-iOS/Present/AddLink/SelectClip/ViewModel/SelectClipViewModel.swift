//
//  SelectClipViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/02/27.
//

import Foundation

final class SelectClipViewModel {
    
    // MARK: - Properties
    
    typealias DataChangeAction = (Bool) -> Void
    private var dataChangeAction: DataChangeAction?
    private var dataEmptyAction: DataChangeAction?
    private var moveBottomAction: DataChangeAction?
    
    typealias NormalChangeAction = () -> Void
    private var unAuthorizedAction: NormalChangeAction?
    private var textFieldEditAction: NormalChangeAction?
    private var saveLinkAction: NormalChangeAction?
    private var saveFailAction: NormalChangeAction?
    
    // MARK: - Data
    
    var selectedClip: [RemindClipModel] = [] {
        didSet {
            dataChangeAction?(!selectedClip.isEmpty)
        }
    }
    
    init() {
        fetchClipData()
    }
}

// MARK: - extension

extension SelectClipViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction,
                               forUnAuthorizedAction: @escaping NormalChangeAction,
                               editAction: @escaping NormalChangeAction,
                               moveAction: @escaping DataChangeAction,
                               saveAction: @escaping NormalChangeAction,
                               failAction: @escaping NormalChangeAction) {
        dataChangeAction = changeAction
        unAuthorizedAction = forUnAuthorizedAction
        textFieldEditAction = editAction
        moveBottomAction = moveAction
        saveLinkAction = saveAction
        saveFailAction = failAction
    }
    
    // 임베드한 링크, 선택한 클립 id - POST
    func postSaveLink(url: String, category: Int?) {
        let request = PostSaveLinkRequestDTO(linkUrl: url,
                                             categoryId: category)
        NetworkService.shared.toastService.postSaveLink(requestBody: request) { result in
            switch result {
            case .success:
                self.saveLinkAction?()
            case .networkFail, .unAuthorized, .notFound:
                self.unAuthorizedAction?()
            case .badRequest, .serverErr:
                self.saveFailAction?()
            default:
                return
            }
        }
    }
    
    // 클립 정보 - GET
    func fetchClipData() {
        NetworkService.shared.clipService.getAllCategory { result in
            switch result {
            case .success(let response):
                var clipDataList: [RemindClipModel] = [RemindClipModel(id: nil,
                                                                       title: "전체 클립",
                                                                       clipCount: response?.data.toastNumberInEntire ?? 0)]
                response?.data.categories.forEach {
                    let clipData = RemindClipModel(id: $0.categoryId,
                                                   title: $0.categoryTitle,
                                                   clipCount: $0.toastNum)
                    clipDataList.append(clipData)
                }
                self.selectedClip = clipDataList
            case .networkFail, .unAuthorized, .notFound:
                self.unAuthorizedAction?()
            default: break
            }
        }
    }
    
    func postAddCategoryAPI(requestBody: String) {
        NetworkService.shared.clipService.postAddCategory(requestBody: PostAddCategoryRequestDTO(categoryTitle: requestBody)) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.textFieldEditAction?()
                }
                self.fetchClipData()
            case .networkFail, .unAuthorized, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
    
    func getCheckCategoryAPI(categoryTitle: String) {
        NetworkService.shared.clipService.getCheckCategory(categoryTitle: categoryTitle) { result in
            switch result {
            case .success(let response):
                if let data = response?.data.isDupicated {
                    if categoryTitle.count != 16 {
                        self.moveBottomAction?(data)
                    }
                }
            case .networkFail, .unAuthorized, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
}

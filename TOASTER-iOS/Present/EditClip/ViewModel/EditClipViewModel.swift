//
//  EditClipViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 2/8/24.
//

import Foundation

final class EditClipViewModel: NSObject {
    
    // MARK: - Properties
    
    typealias DataChangeAction = (Bool) -> Void
    private var moveBottomAction: DataChangeAction?
    
    typealias NormalChangeAction = () -> Void
    private var dataChangeAction: NormalChangeAction?
    private var deleteClipAction: NormalChangeAction?
    private var editClipNameAction: NormalChangeAction?
    private var unAuthorizedAction: NormalChangeAction?
    
    // MARK: - Data
    
    var cellIndex: Int = 0
    var clipList: ClipModel = ClipModel(allClipToastCount: 0,
                                        clips: []) {
        didSet {
            dataChangeAction?()
        }
    }
}

// MARK: - Extensions

extension EditClipViewModel {
    func setupDataChangeAction(changeAction: @escaping NormalChangeAction,
                               moveAction: @escaping DataChangeAction,
                               deleteAction: @escaping NormalChangeAction,
                               editNameAction: @escaping NormalChangeAction,
                               forUnAuthorizedAction: @escaping NormalChangeAction) {
        dataChangeAction = changeAction
        moveBottomAction = moveAction
        deleteClipAction = deleteAction
        editClipNameAction = editNameAction
        unAuthorizedAction = forUnAuthorizedAction
    }
    
    func getAllCategoryAPI() {
        NetworkService.shared.clipService.getAllCategory { result in
            switch result {
            case .success(let response):
                let allClipToastCount = response?.data.toastNumberInEntire
                let clips = response?.data.categories.map {
                    AllClipModel(id: $0.categoryId,
                                 title: $0.categoryTitle,
                                 toastCount: $0.toastNum)
                }
                self.clipList = ClipModel(allClipToastCount: allClipToastCount ?? 0,
                                          clips: clips ?? [])
            case .unAuthorized, .networkFail, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
    
    func deleteCategoryAPI(deleteCategoryDto: Int) {
        NetworkService.shared.clipService.deleteCategory(
            deleteCategoryDto: deleteCategoryDto) { result in
            switch result {
            case .success:
                self.getAllCategoryAPI()
                self.deleteClipAction?()
            case .unAuthorized, .networkFail, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
    
    func patchEditPriorityCategoryAPI(requestBody: ClipPriorityEditModel) {
        NetworkService.shared.clipService.patchEditPriorityCategory(
            requestBody: PatchEditPriorityCategoryRequestDTO(
                categoryId: requestBody.id,
                newPriority: requestBody.priority)) { [weak self] result in
            switch result {
            case .success:
                self?.dataChangeAction?()
            case .unAuthorized, .networkFail, .notFound:
                self?.unAuthorizedAction?()
            default: return
            }
        }
    }
    
    func patchEditaNameCategoryAPI(requestBody: ClipNameEditModel) {
        NetworkService.shared.clipService.patchEditNameCategory(
            requestBody: PatchEditNameCategoryRequestDTO(
                categoryId: requestBody.id,
                newTitle: requestBody.title)) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.editClipNameAction?()
                }
                self.getAllCategoryAPI()
            case .unAuthorized, .networkFail, .notFound:
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
            case .unAuthorized, .networkFail, .notFound:
                self.unAuthorizedAction?()
            default: return
            }
        }
    }
}

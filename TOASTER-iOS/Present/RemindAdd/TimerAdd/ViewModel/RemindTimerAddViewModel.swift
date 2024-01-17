//
//  RemindTimerAddViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/16/24.
//

import Foundation

final class RemindTimerAddViewModel {
    
    // MARK: - Properties
    
    typealias DataChangeAction = () -> Void
    private var dataChangeAction: DataChangeAction?
    private var patchSuccessAction: DataChangeAction?
    private var editSuccessAction: DataChangeAction?
    private var unAuthorizedAction: DataChangeAction?
    private var unProcessableAction: DataChangeAction?
    private var badRequestAction: DataChangeAction?
    
    // MARK: - Data
    
    var remindAddData: RemindTimerAddModel? {
        didSet {
            dataChangeAction?()
        }
    }
}

// MARK: - extension

extension RemindTimerAddViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction,
                               forSuccessAction: @escaping DataChangeAction,
                               forEditSuccessAction: @escaping DataChangeAction,
                               forUnAuthorizedAction: @escaping DataChangeAction,
                               forUnProcessableAction: @escaping DataChangeAction,
                               forBadRequestAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
        patchSuccessAction = forSuccessAction
        editSuccessAction = forEditSuccessAction
        unAuthorizedAction = forUnAuthorizedAction
        unProcessableAction = forUnProcessableAction
        badRequestAction = forBadRequestAction
    }
    
    func fetchClipData(forID: Int) {
        NetworkService.shared.timerService.getDetailTimer(timerId: forID) { result in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    self.remindAddData = RemindTimerAddModel(clipTitle: data.categoryName,
                                                             remindTime: data.remindTime,
                                                             remindDates: data.remindDates)
                }
            default: break
            }
        }
    }
    
    func postClipData(forClipID: Int, forModel: RemindTimerAddModel) {
        NetworkService.shared.timerService.postCreateTimer(requestBody: PostCreateTimerRequestDTO(categoryId: forClipID,
                                                                                                  remindTime: forModel.remindTime,
                                                                                                  remindDates: forModel.remindDates)) { result in
            switch result {
            case .success:
                self.patchSuccessAction?()
            case .unAuthorized, .networkFail:
                self.unAuthorizedAction?()
            case .unProcessable:
                self.unProcessableAction?()
            case .badRequest:
                self.badRequestAction?()
            default: break
            }
        }
    }
    
    func editClipData(forModel: RemindTimerEditModel) {
        NetworkService.shared.timerService.patchEditTimer(timerId: forModel.remindID,
                                                          requestBody: PatchEditTimerRequestDTO(remindTime: forModel.remindTime,
                                                                                                remindDates: forModel.remindDates)) { result in
            switch result {
            case .success:
                self.editSuccessAction?()
            case .unAuthorized, .networkFail:
                self.unProcessableAction?()
            default: break
            }
        }
    }
}

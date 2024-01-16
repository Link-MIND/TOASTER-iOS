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
    private var unAuthorizedAction: DataChangeAction?
    
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
                               forUnAuthorizedAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
        unAuthorizedAction = forUnAuthorizedAction
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
}

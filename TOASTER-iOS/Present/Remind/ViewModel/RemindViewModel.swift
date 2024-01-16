//
//  RemindViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

final class RemindViewModel {
    
    // MARK: - Properties

    typealias DataChangeAction = () -> Void
    private var dataChangeAction: DataChangeAction?
    
    // MARK: - Data

    var timerData: RemindModel = RemindModel(completeTimerModelList: [],
                                             waitTimerModelList: []) {
        didSet {
            dataChangeAction?()
        }
    }
    
    init() {
        fetchTimerData()
    }
}

// MARK: - extension

extension RemindViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
    }
    
    func fetchTimerData() {
        NetworkService.shared.timerService.getTimerMainpage { result in
            switch result {
            case .success(let response):
                var completedList: [CompleteTimerModel] = []
                response?.data.completedTimerList.forEach {
                    completedList.append(CompleteTimerModel(id: $0.timerId,
                                                            remindDay: $0.remindDate,
                                                            remindTime: $0.remindTime,
                                                            clipName: $0.comment))
                }
                var waitList: [WaitTimerModel] = []
                response?.data.waitingTimerList.forEach {
                    waitList.append(WaitTimerModel(id: $0.timerId,
                                                   clipName: $0.comment,
                                                   remindDay: $0.remindDates,
                                                   remindTime: $0.remindTime,
                                                   isEnable: $0.isAlarm))
                }
                self.timerData = RemindModel(completeTimerModelList: completedList,
                                             waitTimerModelList: waitList)
            default: break
            }
        }
    }
}

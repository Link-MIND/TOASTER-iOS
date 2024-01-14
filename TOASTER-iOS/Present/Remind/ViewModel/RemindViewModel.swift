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
    private var dataEmptyAction: DataChangeAction?
    
    private let userDefault = UserDefaults.standard
    private var appAlarmSetting: Bool? {
        didSet {
            
        }
    }
    
    // MARK: - Data

    var timerData: RemindModel = RemindModel.fetchDummyModel() {
        didSet {
            if timerData.completeTimerModelList.count == 0 && 
                timerData.waitTimerModelList.count == 0 {
                dataEmptyAction?()
            } else {
                dataChangeAction?()
            }
        }
    }
    
    init() {
        
    }
}

// MARK: - extension

extension RemindViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction,
                               emptyAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
        dataEmptyAction = emptyAction
    }
}

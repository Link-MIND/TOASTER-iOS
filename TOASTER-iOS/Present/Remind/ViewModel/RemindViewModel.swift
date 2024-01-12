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

    var timerData: RemindModel = RemindModel.fetchDummyModel() {
        didSet {
            dataChangeAction?()
        }
    }
}

// MARK: - extension

extension RemindViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
    }
}

//
//  RemindSelectClipVViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

final class RemindSelectClipViewModel {
    
    // MARK: - Properties

    typealias DataChangeAction = () -> Void
    private var dataChangeAction: DataChangeAction?
    
    // MARK: - Data

    var clipData: [RemindClipModel] = RemindClipModel.fetchDummyData() {
        didSet {
            dataChangeAction?()
        }
    }
}

// MARK: - extension

extension RemindSelectClipViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
    }
}

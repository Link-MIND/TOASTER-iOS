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

    private(set) var clipData: [RemindClipModel] = [] {
        didSet {
            dataChangeAction?()
        }
    }
    
    init() {
        fetchClipData()
    }
}

// MARK: - extension

extension RemindSelectClipViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
    }
    
    func fetchClipData() {
        NetworkService.shared.clipService.getAllCategory { result in
            switch result {
            case .success(let response):
                var clipDataList = response?.data.categories.map {
                    RemindClipModel(id: $0.categoryId,
                                    title: $0.categoryTitle,
                                    clipCount: $0.toastNum)
                }
                self.clipData = clipDataList ?? []
            default: break
            }
        }
    }
}

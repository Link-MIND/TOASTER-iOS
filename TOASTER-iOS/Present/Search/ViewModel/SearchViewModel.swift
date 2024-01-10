//
//  SearchViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/9/24.
//

import Foundation

final class SearchViewModel: NSObject {
    
    // MARK: - Properties

    typealias DataChangeAction = () -> Void
    private var dataChangeAction: DataChangeAction?
    private var dataEmptyAction: DataChangeAction?
    
    // MARK: - Data

    var searchResultData: SearchResultModel = SearchResultModel.fetchDummyData() {
        didSet {
            if searchResultData.clipList.count == 0 && 
                searchResultData.detailClipList.count == 0 {
                dataEmptyAction?()
            } else {
                dataChangeAction?()
            }
        }
    }
}

// MARK: - extension

extension SearchViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction,
                               emptyAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
        dataEmptyAction = emptyAction
    }
    
    func empty() {
        searchResultData = SearchResultModel(detailClipList: [], clipList: [])
    }
}

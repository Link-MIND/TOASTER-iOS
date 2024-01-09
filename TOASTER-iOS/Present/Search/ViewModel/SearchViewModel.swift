//
//  SearchViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/9/24.
//

import Foundation

final class SearchViewModel: NSObject {
    
    typealias DataChangeAction = () -> Void
    private var dataChangeAction: DataChangeAction?
    private var dataEmptyAction: DataChangeAction?
    
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

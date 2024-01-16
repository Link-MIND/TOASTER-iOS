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
    private var unAuthorizedAction: DataChangeAction?
    
    // MARK: - Data
    
    var searchResultData: SearchResultModel = SearchResultModel(detailClipList: [],
                                                                clipList: []) {
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
                               emptyAction: @escaping DataChangeAction,
                               forUnAuthorizedAction: @escaping DataChangeAction) {
        dataChangeAction = changeAction
        dataEmptyAction = emptyAction
        unAuthorizedAction = forUnAuthorizedAction
    }
    
    func fetchSearchResult(forText: String) {
        NetworkService.shared.searchService.getMainPageSearch(searchText: forText) { result in
            switch result {
            case .success(let response):
                var detailClipList: [SearchResultDetailClipModel] = []
                response?.data.toasts.forEach {
                    detailClipList.append(SearchResultDetailClipModel(iD: $0.toastId,
                                                                      title: $0.toastTitle,
                                                                      link: $0.linkUrl,
                                                                      imageURL: $0.thumbnailUrl,
                                                                      clipTitle: $0.categoryTitle))
                }
                var clipList: [SearchResultClipModel] = []
                response?.data.categories.forEach {
                    clipList.append(SearchResultClipModel(iD: $0.categoryId,
                                                          title: $0.title,
                                                          numberOfDetailClip: $0.toastNum))
                }
                self.searchResultData = SearchResultModel(detailClipList: detailClipList,
                                                          clipList: clipList)
            case .unAuthorized:
                self.unAuthorizedAction?()
            default: break
            }
        }
    }
}

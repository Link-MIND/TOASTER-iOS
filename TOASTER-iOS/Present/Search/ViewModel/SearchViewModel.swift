//
//  SearchViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/9/24.
//

import Combine
import Foundation

final class SearchViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    private(set) var searchResults: SearchResultModel = SearchResultModel(
        detailClipList: [],
        clipList: []
    )
    
    // MARK: - Input State
    
    struct Input {
        let searchButtonTapped: Driver<String>
        let clearButtonTapped: Driver<Void>
        let textFieldBeginEdited: Driver<Void>
    }
    
    // MARK: - Output State
    
    struct Output {
        let loadToSearchResults = PassthroughSubject<Bool, Never>()
        let startSearching = PassthroughSubject<Void, Never>()
        let isSearching = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.searchButtonTapped
            .filter { !$0.isEmpty }
            .networkFlatMap(self) { context, text in
                context.fetchSearchResult(forText: text)
            }
            .sink { [weak self] result in
                self?.searchResults = result
                output.loadToSearchResults.send(result.detailClipList.isEmpty && result.clipList.isEmpty)
                output.isSearching.send(false)
            }.store(in: cancelBag)
        
        input.clearButtonTapped
            .sink { [weak self] in
                self?.searchResults = SearchResultModel(detailClipList: [], clipList: [])
                output.loadToSearchResults.send(false)
                output.startSearching.send()
                output.isSearching.send(true)
            }.store(in: cancelBag)
        
        input.textFieldBeginEdited
            .sink { _ in
                output.isSearching.send(true)
            }.store(in: cancelBag)
                
        return output
    }
}

// MARK: - Network

private extension SearchViewModel {
    func fetchSearchResult(forText: String) -> AnyPublisher<SearchResultModel, Error> {
        return Future<SearchResultModel, Error> { promise in
            NetworkService.shared.searchService.getMainPageSearch(searchText: forText) { result in
                switch result {
                case .success(let response):
                    let detailClips = response?.data?.toasts.map {
                        SearchResultDetailClipModel(
                            iD: $0.toastId,
                            title: $0.toastTitle,
                            link: $0.linkUrl,
                            imageURL: $0.thumbnailUrl,
                            clipTitle: $0.categoryTitle,
                            isRead: $0.isRead
                        )
                    }
                    let clips = response?.data?.categories.map {
                        SearchResultClipModel(
                            iD: $0.categoryId,
                            title: $0.title,
                            numberOfDetailClip: $0.toastNum
                        )
                    }
                    promise(
                        .success(
                            SearchResultModel(
                                detailClipList: detailClips ?? [],
                                clipList: clips ?? []
                            )
                        )
                    )
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default:
                    return
                }
            }
        }.eraseToAnyPublisher()
    }
}

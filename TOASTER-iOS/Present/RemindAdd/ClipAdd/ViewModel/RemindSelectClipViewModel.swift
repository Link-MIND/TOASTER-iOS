//
//  RemindSelectClipVViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Combine
import UIKit

final class RemindSelectClipViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    private(set) var clips: [RemindClipModel] = []
    
    // MARK: - Input State
    
    struct Input {
        let requestClipList: Driver<Void>
    }
    
    // MARK: - Output State
    
    struct Output {
        let needToReload = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Method

    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestClipList
            .networkFlatMap(self) { context, _ in
                context.fetchClipData()
            }
            .sink { [weak self] clips in
                self?.clips = clips
                output.needToReload.send()
            }.store(in: cancelBag)
        return output
    }
}

// MARK: - Network

extension RemindSelectClipViewModel {
    func fetchClipData() -> AnyPublisher<[RemindClipModel], Error> {
        return Future<[RemindClipModel], Error> { promise in
            NetworkService.shared.clipService.getAllCategory { result in
                switch result {
                case .success(let response):
                    var clips: [RemindClipModel] = [
                        RemindClipModel(
                            id: 0,
                            title: "전체 클립",
                            clipCount: response?.data.toastNumberInEntire ?? 0
                        )
                    ]
                    
                    if let categories = response?.data.categories {
                        categories.forEach { category in
                            clips.append(
                                RemindClipModel(
                                    id: category.categoryId,
                                    title: category.categoryTitle,
                                    clipCount: category.toastNum
                                )
                            )
                        }
                    }
                    
                    promise(.success(clips))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default: break
                }
            }
        }.eraseToAnyPublisher()
    }
}

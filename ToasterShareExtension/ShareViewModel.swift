//
//  ShareViewModel.swift
//  ToasterShareExtension
//
//  Created by ParkJunHyuk on 9/29/24.
//

import Foundation
import Combine

final class ShareViewModel: ViewModelType {

    private let appURL = "TOASTER://"
    private var urlString = ""
    
    struct Input {
        let selectedClip: AnyPublisher<RemindClipModel, Never>
        let completeButtonTap: AnyPublisher<Void, Never>
        let closeButtonTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let isSeleted: AnyPublisher<Bool, Never>
        let completeButtonAction: AnyPublisher<Bool, Never>
        let closeButtonAction: AnyPublisher<Void, Never>
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let categoryIDPublisher = input.selectedClip
            .map { clip in
                clip.id == 0 ? nil : clip.id
            }
            .eraseToAnyPublisher()
        
        let isSelectedPublisher = input.selectedClip
            .map { _ in true }
            .eraseToAnyPublisher()

        let saveLinkResultPublisher = input.completeButtonTap
            .combineLatest(categoryIDPublisher)
            .map { _, categoryID in categoryID }
            .networkFlatMap(self, { context, categoryID in
                context.postSaveLink(id: categoryID)
            })
            .eraseToAnyPublisher()

        return Output(
            isSeleted: isSelectedPublisher,
            completeButtonAction: saveLinkResultPublisher,
            closeButtonAction: input.closeButtonTap
        )
    }
    
    func bindUrl(_ url: String) {
        self.urlString = url
    }
    
    func readAppURL() -> String {
        return appURL
    }
}

// MARK: - API Methods

private extension ShareViewModel {
    func postSaveLink(id: Int?) -> AnyPublisher<Bool, ToasterError> {
        let request = PostSaveLinkRequestDTO(linkUrl: self.urlString, categoryId: id)
        
        return NetworkService.shared.toastService.postSaveLink(requestBody: request)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
}

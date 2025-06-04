//
//  LinkWebViewModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/2/24.
//

import Combine
import UIKit

final class LinkWebViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    
    // MARK: - Input State
    
    struct Input {
        let readLinkButtonTapped: Driver<LinkReadEditModel>
    }
    
    // MARK: - Output State
    
    struct Output {
        let isRead = PassthroughSubject<Bool, Never>()
        let navigateToLogin = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Method
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.readLinkButtonTapped
            .networkFlatMap(self, { context, model in
                context.patchOpenLinkAPI(requestBody: model)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { isRead in
                output.isRead.send(!isRead)
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Network

private extension LinkWebViewModel {
    func patchOpenLinkAPI(requestBody: LinkReadEditModel) -> AnyPublisher<Bool, ToasterError> {
        return NetworkService.shared.toastService.patchOpenLink(
            requestBody: PatchOpenLinkRequestDTO(
                toastId: requestBody.toastId,
                isRead: requestBody.isRead
            )
        )
        .map { response in
            return !response.data.isRead
        }
        .eraseToAnyPublisher()
    }
}

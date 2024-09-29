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
        let readLinkButtonTapped: AnyPublisher<LinkReadEditModel, Never>
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
            .flatMap { [weak self] model -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Just(false)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.patchOpenLinkAPI(requestBody: model)
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): print("Error occurred: \(error)")
                    }
                },
                receiveValue: { isRead in
                    output.isRead.send(!isRead)
                }
            ).store(in: cancelBag)
        
        return output
    }
}

// MARK: - Network

private extension LinkWebViewModel {
    func patchOpenLinkAPI(requestBody: LinkReadEditModel) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            NetworkService.shared.toastService.patchOpenLink(
                requestBody: PatchOpenLinkRequestDTO(
                    toastId: requestBody.toastId,
                    isRead: requestBody.isRead
                )
            ) { result in
               switch result {
               case .success:
                   promise(.success(!requestBody.isRead))
               case .unAuthorized, .networkFail, .notFound:
                   let output = Output()
                   output.navigateToLogin.send()
               default: return
               }
           }
        }.eraseToAnyPublisher()
    }
}

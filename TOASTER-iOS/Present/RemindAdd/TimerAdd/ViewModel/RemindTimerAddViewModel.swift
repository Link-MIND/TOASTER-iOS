//
//  RemindTimerAddViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/16/24.
//

import Combine
import UIKit

final class RemindTimerAddViewModel: ViewModelType {
    
    private var cancelBag = CancelBag()
    private(set) var remindAddData: RemindTimerAddModel?
    
    // MARK: - Input State
    
    struct Input {
        let requestGetDetailTimer: Driver<Int>
        let completeAddButtonTapped: Driver<(Int, RemindTimerAddModel)>
        let completeEditButtonTapped: Driver<RemindTimerEditModel>
    }
    
    // MARK: - Output State
    
    struct Output {
        let onSetView = PassthroughSubject<Void, Never>()
        let onSetTimerSuccess = PassthroughSubject<Void, Never>()
        let onEditTimerSuccess = PassthroughSubject<Void, Never>()
        let onError = PassthroughSubject<String, Never>()
    }
    
    // MARK: - Method

    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestGetDetailTimer
            .networkFlatMap(self) { context, timerID in
                context.getDetailTimerAPI(forID: timerID)
            }
            .sink { [weak self] data in
                self?.remindAddData = data
                output.onSetView.send()
            }.store(in: cancelBag)
        
        input.completeAddButtonTapped
            .networkFlatMap(self, { context, body in
                context.postCreateTimerAPI(forClipID: body.0, forModel: body.1)
            }, onError: { error in
                switch error as? NetworkResult<Error> {
                case .unProcessable:
                    output.onError.send(StringLiterals.ToastMessage.noticeSetTimer)
                case .badRequest:
                    output.onError.send(StringLiterals.ToastMessage.noticeMaxTimer)
                default: break
                }
            })
            .sink {
                output.onSetTimerSuccess.send()
            }.store(in: cancelBag)
        
        input.completeEditButtonTapped
            .networkFlatMap(self) { context, model in
                context.patchEditTimerAPI(forModel: model)
            }
            .sink {
                output.onEditTimerSuccess.send()
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Network

extension RemindTimerAddViewModel {
    func getDetailTimerAPI(forID: Int) -> AnyPublisher<RemindTimerAddModel?, Error> {
        return Future<RemindTimerAddModel?, Error> { promise in
            NetworkService.shared.timerService.getDetailTimer(timerId: forID) { result in
                switch result {
                case .success(let response):
                    var remindAddData: RemindTimerAddModel?
                    if let data = response?.data {
                        remindAddData = RemindTimerAddModel(
                            clipTitle: data.categoryName,
                            remindTime: data.remindTime,
                            remindDates: data.remindDates
                        )
                    }
                    promise(.success(remindAddData))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                default: break
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func postCreateTimerAPI(
        forClipID: Int,
        forModel: RemindTimerAddModel
    ) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            NetworkService.shared.timerService.postCreateTimer(
                requestBody: PostCreateTimerRequestDTO(
                    categoryId: forClipID,
                    remindTime: forModel.remindTime,
                    remindDates: forModel.remindDates
                )
            ) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unAuthorized))
                case .unProcessable:
                    promise(.failure(NetworkResult<Error>.unProcessable))
                case .badRequest:
                    promise(.failure(NetworkResult<Error>.badRequest))
                default: break
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func patchEditTimerAPI(forModel: RemindTimerEditModel) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            NetworkService.shared.timerService.patchEditTimer(
                timerId: forModel.remindID,
                requestBody: PatchEditTimerRequestDTO(
                    remindTime: forModel.remindTime,
                    remindDates: forModel.remindDates
                )
            ) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .unAuthorized, .networkFail, .notFound:
                    promise(.failure(NetworkResult<Error>.unProcessable))
                default: break
                }
            }
        }.eraseToAnyPublisher()
    }
}

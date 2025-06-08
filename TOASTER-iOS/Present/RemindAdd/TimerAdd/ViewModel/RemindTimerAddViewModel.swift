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
        let navigateToLogin = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Method

    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.requestGetDetailTimer
            .networkFlatMap(self, { context, timerID in
                context.getDetailTimerAPI(forID: timerID)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink { [weak self] data in
                self?.remindAddData = data
                output.onSetView.send()
            }.store(in: cancelBag)
        
        input.completeAddButtonTapped
            .networkFlatMap(self, { context, body in
                context.postCreateTimerAPI(forClipID: body.0, forModel: body.1)
            }, onError: { error in
                guard let error = error as? ToasterError else { return }
                switch error {
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
            .networkFlatMap(self, { context, model in
                context.patchEditTimerAPI(forModel: model)
            }, onError: { _ in
                output.navigateToLogin.send()
            })
            .sink {
                output.onEditTimerSuccess.send()
            }.store(in: cancelBag)
        
        return output
    }
}

// MARK: - Network

extension RemindTimerAddViewModel {
    func getDetailTimerAPI(forID: Int) -> AnyPublisher<RemindTimerAddModel, ToasterError> {
        return NetworkService.shared.timerService.getDetailTimer(timerId: forID)
            .map { response in
                var remindAddData: RemindTimerAddModel
                remindAddData = RemindTimerAddModel(
                    clipTitle: response.data .categoryName,
                    remindTime: response.data .remindTime,
                    remindDates: response.data .remindDates
                )
                return remindAddData
            }
            .eraseToAnyPublisher()
    }
    
    func postCreateTimerAPI(
        forClipID: Int,
        forModel: RemindTimerAddModel
    ) -> AnyPublisher<Void, ToasterError> {
        return NetworkService.shared.timerService.postCreateTimer(
            requestBody: PostCreateTimerRequestDTO(
                categoryId: forClipID,
                remindTime: forModel.remindTime,
                remindDates: forModel.remindDates
            )
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }
    
    func patchEditTimerAPI(forModel: RemindTimerEditModel) -> AnyPublisher<Void, ToasterError> {
        NetworkService.shared.timerService.patchEditTimer(
            timerId: forModel.remindID,
            requestBody: PatchEditTimerRequestDTO(
                remindTime: forModel.remindTime,
                remindDates: forModel.remindDates
            )
        )
        .map { _ in () }
        .eraseToAnyPublisher()
    }
}

//
//  RemindModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

struct RemindModel {
    let completeTimerModelList: [CompleteTimerModel]
    let waitTimerModelList: [WaitTimerModel]
}

struct CompleteTimerModel {
    let id: Int
    let remindDay: String
    let remindTime: String
    let clipName: String
}

struct WaitTimerModel {
    let id: Int
    let clipName: String
    let remindDay: String
    let remindTime: String
    let isEnable: Bool
}

extension RemindModel {
    
    // TODO: - 더미 데이터 (삭제 예정)
    
    static func fetchDummyModel() -> RemindModel {
        let complete = [CompleteTimerModel(id: 0,
                                           remindDay: "일요일",
                                           remindTime: "오전 10:00",
                                           clipName: "주말 나들이"),
                        CompleteTimerModel(id: 1,
                                           remindDay: "월요일",
                                           remindTime: "오전 11:00",
                                           clipName: "점심 뭐먹지")]
        let wait = [WaitTimerModel(id: 0,
                                   clipName: "월요병 퇴치",
                                   remindDay: "월",
                                   remindTime: "오전 10시",
                                   isEnable: true),
                    WaitTimerModel(id: 1,
                                   clipName: "주말 나들이",
                                   remindDay: "토, 일",
                                   remindTime: "오전 10시",
                                   isEnable: false),
                    WaitTimerModel(id: 2,
                                   clipName: "점심 뭐먹지",
                                   remindDay: "월, 금",
                                   remindTime: "오전 11시",
                                   isEnable: true)]
        
        return RemindModel(completeTimerModelList: complete,
                           waitTimerModelList: wait)
    }
}

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
    let clipID: Int
    let clipName: String
}

struct WaitTimerModel {
    let id: Int
    let clipID: Int
    let clipName: String
    let remindDay: String
    let remindTime: String
    let isEnable: Bool
}

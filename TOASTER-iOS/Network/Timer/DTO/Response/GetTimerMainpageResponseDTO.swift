//
//  GetTimerMainpageResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

struct GetTimerMainpageResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetTimerMainpageResponseData
}

struct GetTimerMainpageResponseData: Codable {
    let completedTimerList: [CompletedTimerList]
    let waitingTimerList: [WaitingTimerList]
}

struct CompletedTimerList: Codable {
    let timerId: Int
    let categoryId: Int
    let remindTime: String
    let remindDate: String
    let comment: String
}

struct WaitingTimerList: Codable {
    let timerId: Int
    let remindTime: String
    let remindDates: String
    let isAlarm: Bool
    let updateAt: String
    let comment: String
    let categoryId: Int
}

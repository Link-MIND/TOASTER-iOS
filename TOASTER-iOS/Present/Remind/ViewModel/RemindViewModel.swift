//
//  RemindViewModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation
import UserNotifications

final class RemindViewModel {
    
    // MARK: - Properties
    
    typealias DataChangeAction = (RemindViewType) -> Void
    private var dataChangeAction: DataChangeAction?
    
    typealias NormalChangeAction = () -> Void
    private var bottomSheetAction: NormalChangeAction?
    private var unAuthorizedAction: NormalChangeAction?
    private var deleteTimerAction: NormalChangeAction?
    
    private let userDefault = UserDefaults.standard
    
    /// RemindViewType을 저장하기 위한 프로퍼티
    private var remindViewType: RemindViewType = .deviceOnAppOnNoneData {
        didSet {
            DispatchQueue.main.async {
                self.dataChangeAction?(self.remindViewType)
            }
        }
    }
    
    private var deviceAlarmSetting: Bool? {
        didSet {
            setupAlarm(forDeviceAlarm: deviceAlarmSetting)
        }
    }
    private var appAlarmSetting: Bool = true {
        didSet {
            setupAlarm(forDeviceAlarm: deviceAlarmSetting)
        }
    }
    
    // MARK: - Data
    
    private(set) var timerData: RemindModel = RemindModel(completeTimerModelList: [],
                                                          waitTimerModelList: []) {
        didSet {
            switch remindViewType {
            case .deviceOnAppOnExistData, .deviceOnAppOnNoneData:
                if timerData.completeTimerModelList.count == 0 &&
                    timerData.waitTimerModelList.count == 0 {
                    remindViewType = .deviceOnAppOnNoneData
                } else {
                    remindViewType = .deviceOnAppOnExistData
                }
            default: break
            }
        }
    }
    
    init() {
        fetchTimerData()
    }
}

// MARK: - extension

extension RemindViewModel {
    func setupDataChangeAction(changeAction: @escaping DataChangeAction,
                               normalAction: @escaping NormalChangeAction,
                               forDeleteTimerAction: @escaping NormalChangeAction,
                               forUnAuthorizedAction: @escaping NormalChangeAction) {
        dataChangeAction = changeAction
        bottomSheetAction = normalAction
        deleteTimerAction = forDeleteTimerAction
        unAuthorizedAction = forUnAuthorizedAction
    }
    
    /// 기기의 알림 설정, 앱 알림 설정 분기처리
    func fetchAlarmCheck() {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .notDetermined:
                DispatchQueue.main.async {
                    self.remindViewType = .deviceOnAppOnNoneData
                    self.bottomSheetAction?()
                }
            case .denied:
                self.deviceAlarmSetting = false
            case .authorized:
                self.deviceAlarmSetting = true
            default:
                print("unknown Error")
            }
        }
        if let isAppOn = userDefault.object(forKey: "isAppAlarmOn") as? Bool {
            appAlarmSetting = isAppOn
        }
    }
    
    func fetchTimerData() {
        NetworkService.shared.timerService.getTimerMainpage { result in
            switch result {
            case .success(let response):
                let completedList = response?.data.completedTimerList.map {
                    CompleteTimerModel(id: $0.timerId,
                                       remindDay: $0.remindDate,
                                       remindTime: $0.remindTime,
                                       clipID: $0.categoryId,
                                       clipName: $0.comment)
                }
                let waitList = response?.data.waitingTimerList.map {
                    WaitTimerModel(id: $0.timerId,
                                   clipID: $0.categoryId,
                                   clipName: $0.comment,
                                   remindDay: $0.remindDates,
                                   remindTime: $0.remindTime,
                                   isEnable: $0.isAlarm)
                }
                self.timerData = RemindModel(completeTimerModelList: completedList ?? [],
                                             waitTimerModelList: waitList ?? [])
            case .unAuthorized, .networkFail:
                self.unAuthorizedAction?()
            default: break
            }
        }
    }
    
    func deleteTimerData(timerID: Int) {
        NetworkService.shared.timerService.deleteTimer(timerId: timerID) { result in
            switch result {
            case .success:
                self.fetchTimerData()
                self.deleteTimerAction?()
            case .unAuthorized, .networkFail:
                self.unAuthorizedAction?()
            default: break
            }
        }
    }
    
    func patchTimerData(timerID: Int) {
        NetworkService.shared.timerService.patchEditAlarmTimer(timerId: timerID) { result in
            switch result {
            case .success:
                self.fetchTimerData()
            case .unAuthorized, .networkFail:
                self.unAuthorizedAction?()
            default: break
            }
        }
    }
}

private extension RemindViewModel {
    /// 기기 설정과 앱 설정에 따른 viewType을 업데이트하는 함수
    func setupAlarm(forDeviceAlarm: Bool?) {
        if let forDeviceAlarm {
            if forDeviceAlarm == false {    // device 알람이 꺼져있을 때
                if appAlarmSetting == false {     // device 알람이 꺼져있고, 앱 알람도 꺼져있을 때
                    remindViewType = .deviceOffAppOff
                } else {                          // device 알람이 꺼져있고, 앱 알람이 켜져있을 때
                    remindViewType = .deviceOffAppOn
                }
            } else {                        // device 알람이 켜져있을 때
                if appAlarmSetting == false {     // device 알람이 켜져있고, 앱 알람이 꺼져있을 때
                    remindViewType = .deviceOnAppOff
                } else {
                    self.remindViewType = .deviceOnAppOnExistData
                    self.fetchTimerData()
                }
            }
        }
    }
}

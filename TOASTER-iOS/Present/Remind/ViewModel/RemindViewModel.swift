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

    var timerData: RemindModel = RemindModel(completeTimerModelList: [],
                                             waitTimerModelList: []) {
        didSet {
            if timerData.completeTimerModelList.count == 0 && 
                timerData.waitTimerModelList.count == 0 {
                remindViewType = .deviceOnAppOnNoneData
            } else {
                remindViewType = .deviceOnAppOnExistData
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
                               forUnAuthorizedAction: @escaping NormalChangeAction) {
        dataChangeAction = changeAction
        bottomSheetAction = normalAction
        unAuthorizedAction = forUnAuthorizedAction
    }
    
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
                var completedList: [CompleteTimerModel] = []
                response?.data.completedTimerList.forEach {
                    completedList.append(CompleteTimerModel(id: $0.timerId,
                                                            remindDay: $0.remindDate,
                                                            remindTime: $0.remindTime,
                                                            clipName: $0.comment))
                }
                var waitList: [WaitTimerModel] = []
                response?.data.waitingTimerList.forEach {
                    waitList.append(WaitTimerModel(id: $0.timerId,
                                                   clipName: $0.comment,
                                                   remindDay: $0.remindDates,
                                                   remindTime: $0.remindTime,
                                                   isEnable: $0.isAlarm))
                }
                self.timerData = RemindModel(completeTimerModelList: completedList,
                                             waitTimerModelList: waitList)
            case .unAuthorized:
                self.unAuthorizedAction?()
            default: break
            }
        }
    }
}

private extension RemindViewModel {
    func setupAlarm(forDeviceAlarm: Bool?) {
        if let deviceAlarm = forDeviceAlarm {
            if deviceAlarm == false {    // device 알람이 꺼져있을 때
                if appAlarmSetting == false {     // device 알람이 꺼져있고, 앱 알람도 꺼져있을 때
                    remindViewType = .deviceOffAppOff
                } else {                          // device 알람이 꺼져있고, 앱 알람이 켜져있을 때
                    remindViewType = .deviceOffAppOn
                }
            } else {                        // device 알람이 켜져있을 때
                if appAlarmSetting == false {     // device 알람이 켜져있고, 앱 알람이 꺼져있을 때
                    remindViewType = .deviceOnAppOff
                } else {
                    self.fetchTimerData()
                }
            }
        }
    }
}

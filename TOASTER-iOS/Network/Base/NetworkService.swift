//
//  NetworkService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()

    private init() {}
    
    let authService: AuthAPIServiceProtocol = AuthAPIService()
    let userService: UserAPIServiceProtocol = UserAPIService()
    let toastService: ToasterAPIServiceProtocol = ToasterAPIService()
    let clipService: ClipAPIServiceProtocol = ClipAPIService()
    let searchService: SearchAPIServiceProtocol = SearchAPIService()
    let timerService: TimerAPIServiceProtocol = TimerAPIService()
}

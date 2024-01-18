//
//  PatchPushAlarmResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct PatchPushAlarmResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PatchPushAlarmResponseData?
}

struct PatchPushAlarmResponseData: Codable {
    let isAllowed: Bool
}

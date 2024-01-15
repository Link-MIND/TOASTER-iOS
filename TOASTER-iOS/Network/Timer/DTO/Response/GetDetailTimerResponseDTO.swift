//
//  GetDetailTimerResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

struct GetDetailTimerResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetDetailTimerResponseData
}

struct GetDetailTimerResponseData: Codable {
    let categoryName, remindTime: String
    let remindDates: [Int]
}

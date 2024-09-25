//
//  GetPopupInfoResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/23/24.
//

import Foundation

struct GetPopupInfoResponseDTO: Codable {
    let code: Int
    let message: String
    let data: GetPopupInfoResponseData
}

struct GetPopupInfoResponseData: Codable {
    let popupList: [PopupList]
}

struct PopupList: Codable {
    let id: Int
    let image, activeStartDate, activeEndDate, linkUrl: String
}

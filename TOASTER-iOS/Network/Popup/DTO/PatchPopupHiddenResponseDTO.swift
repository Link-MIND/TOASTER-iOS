//
//  PatchPopupHiddenResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/23/24.
//

import Foundation

struct PatchPopupHiddenResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PatchPopupHiddenResponseData
}

struct PatchPopupHiddenResponseData: Codable {
    let popupID: Int
    let hideUntil: String
}

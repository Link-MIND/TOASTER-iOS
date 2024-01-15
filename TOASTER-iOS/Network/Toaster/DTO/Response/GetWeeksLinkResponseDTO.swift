//
//  GetWeeksLinkResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

struct GetWeeksLinkResponseDTO: Codable {
    let code: Int
    let message: String
    let data: [GetWeeksLinkResponseData]
}

struct GetWeeksLinkResponseData: Codable {
    let toastId: Int
    let toastTitle: String
    let toastImg: String?
    let toastLink: String
}

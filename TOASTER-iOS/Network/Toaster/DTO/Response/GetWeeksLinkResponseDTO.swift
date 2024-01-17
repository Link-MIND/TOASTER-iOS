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
    let linkId: Int
    let linkTitle: String
    let linkImg: String?
    let linkUrl: String
}

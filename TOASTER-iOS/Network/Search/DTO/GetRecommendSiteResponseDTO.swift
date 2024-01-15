//
//  GetRecommendSiteResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/15/24.
//

import Foundation

struct GetRecommendSiteResponseDTO: Codable {
    let code: Int
    let message: String
    let data: [GetRecommendSiteResponseData]
}

struct GetRecommendSiteResponseData: Codable {
    let siteId: Int
    let siteTitle: String?
    let siteUrl: String?
    let siteImg: String?
    let siteSub: String?
}

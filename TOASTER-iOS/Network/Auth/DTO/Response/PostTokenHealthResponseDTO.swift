//
//  PostTokenHealthResponseDTO.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 4/3/24.
//

import Foundation

struct PostTokenHealthResponseDTO: Codable {
    let code: Int
    let message: String
    let data: PostTokenHealthResponseData
}

struct PostTokenHealthResponseData: Codable {
    let tokenHealth: Bool
}

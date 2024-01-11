//
//  DeleteWithdrawResponseDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct DeleteWithdrawResponseDTO: Codable {
    let code: Int
    let message: String
    let data: String?
}

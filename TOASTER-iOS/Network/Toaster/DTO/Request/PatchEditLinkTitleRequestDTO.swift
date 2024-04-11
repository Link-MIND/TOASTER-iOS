//
//  PatchEditLinkTitleRequestDTO.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/04/09.
//

import Foundation

struct PatchEditLinkTitleRequestDTO: Codable {
    let toastId: Int
    let newTitle: String
}

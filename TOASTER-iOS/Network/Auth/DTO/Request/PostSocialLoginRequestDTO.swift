//
//  PostSocialLoginRequestDTO.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

struct PostSocialLoginRequestDTO: Codable {
    let socialType: String
    let fcmToken: String?
}

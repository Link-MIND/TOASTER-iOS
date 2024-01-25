//
//  ClipModel.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/25/24.
//

import Foundation

struct ClipModel {
    let allClipToastCount: Int
    let clips: [AllClipModel]
}

struct AllClipModel {
    let id: Int
    let title: String
    let toastCount: Int
}

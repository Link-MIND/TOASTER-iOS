//
//  RemindClipModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

struct RemindClipModel {
    let title: String
    let clipCount: Int
}

extension RemindClipModel {
    static func fetchDummyData() -> [RemindClipModel] {
        return [RemindClipModel(title: "주말 나들이",
                                clipCount: 33),
                RemindClipModel(title: "아침 뭐먹지",
                                        clipCount: 2),
                RemindClipModel(title: "안뇽",
                                        clipCount: 45)]
    }
}

//
//  RemindClipModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import Foundation

struct RemindClipModel {
    let id: Int
    let title: String
    let clipCount: Int
}

extension RemindClipModel {
    static func fetchDummyData() -> [RemindClipModel] {
        return [RemindClipModel(id: 0,
                                title: "주말 나들이",
                                clipCount: 33),
                RemindClipModel(id: 1,
                                title: "아침 뭐먹지",
                                clipCount: 2),
                RemindClipModel(id: 2,
                                title: "안뇽",
                                clipCount: 45)]
    }
}

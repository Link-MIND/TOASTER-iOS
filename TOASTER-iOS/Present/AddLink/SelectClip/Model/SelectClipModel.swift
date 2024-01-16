//
//  SelectClipModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/15.
//

import Foundation

struct SelectClipModel {
    let id: Int
    let title: String
    let clipCount: Int
}

extension SelectClipModel {
    
    // TODO: - 더미 데이터 삭제
    
    static func fetchDummyData() -> [SelectClipModel] {
        return [SelectClipModel(id: 0,
                                title: "링마인드",
                                clipCount: 33),
                SelectClipModel(id: 1,
                                title: "김가혀니",
                                clipCount: 2),
                SelectClipModel(id: 2,
                                title: "두솝아요",
                                clipCount: 45)]
    }
}

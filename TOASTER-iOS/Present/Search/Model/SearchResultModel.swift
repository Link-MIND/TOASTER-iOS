//
//  SearchResultModel.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/9/24.
//

import Foundation

struct SearchResultModel {
    let detailClipList: [SearchResultDetailClipModel]
    let clipList: [SearchResultClipModel]
}

struct SearchResultDetailClipModel {
    let iD: Int
    let title: String
    let link: String
    let imageURL: String
    let clipTitle: String?
}

struct SearchResultClipModel {
    let iD: Int
    let title: String
    let numberOfDetailClip: Int
}

extension SearchResultModel {
    
    // TODO: - 더미 데이터 삭제 예정
    
    static func fetchDummyData() -> SearchResultModel {
        let detailClipModelList = [SearchResultDetailClipModel(iD: 0,
                                                               title: "토스트",
                                                               link: "www.토스트.com",
                                                               imageURL: "www",
                                                               clipTitle: "토스트 관련"),
                                   SearchResultDetailClipModel(iD: 1,
                                                               title: "토스트 맛있당",
                                                               link: "www.토스트맛있겠지~.com",
                                                               imageURL: "www",
                                                               clipTitle: nil),
                                   SearchResultDetailClipModel(iD: 2,
                                                               title: "토스트 먹방",
                                                               link: "www.토스터화이팅.com",
                                                               imageURL: "www",
                                                               clipTitle: nil),
                                   SearchResultDetailClipModel(iD: 3,
                                                               title: "토스트 아저씨",
                                                               link: "www.토스트아저씨토스트하나만ㄷ주세용.com",
                                                               imageURL: "www",
                                                               clipTitle: "토스트 관련")]
        
        let clipModelList = [SearchResultClipModel(iD: 0,
                                                   title: "토스터",
                                                   numberOfDetailClip: 33),
                             SearchResultClipModel(iD: 1,
                                                   title: "토스터기",
                                                   numberOfDetailClip: 44),
                             SearchResultClipModel(iD: 2,
                                                   title: "토스트 맛있겠당",
                                                   numberOfDetailClip: 325)]
        
        return SearchResultModel(detailClipList: detailClipModelList,
                                 clipList: clipModelList)
    }
}

//
//  StringLiterals.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/01.
//

import Foundation

enum StringLiterals {
    
    // MARK: - 탭바와 관련된 String
    
    enum Tabbar {
        enum Title {
            static let home = "HOME"
            static let clip = "CLIP"
            static let timer = "TIMER"
            static let my = "MY"
        }
    }
    
    // MARK: - 네비게이션바와 관련된 String
    
    enum NavigationBar {
        enum Title {
            static let allClip = "전체 클립"
        }
    }

    // MARK: - 바텀시트와 관련된 String

    enum BottomSheet {
        enum Title {
            static let modified = "수정하기"
        }
        enum Placeholder {
            static let addClip = "클립의 이름을 입력해 주세요"
        }
        enum Button {
            static let complete = "확인"
            static let delete = "삭제"
        }
    }
    
    // MARK: - 토스트 메시지와 관련된 String

    enum Toast {
        enum Message {
            static let completeDeleteLink = "링크 삭제 완료"
        }
    }
    
    // MARK: - 클립 뷰에서 사용되는 String
    
    enum Clip {
        enum Title {
            static let addClip = "클립 추가"
            static let emptyLabel = "클립을 추가해 \n 링크를 정리해보세요!"
            static let detailEmptyLabel = "아직 클립에 저장된 링크가 없어요 \n 아래 + 버튼을 통해 링크를 저장해보세요!"
            static let edit = "편집"
        }
        enum Segment {
            static let all = "전체"
            static let read = "열람"
            static let unread = "미열람"
        }
    }
}

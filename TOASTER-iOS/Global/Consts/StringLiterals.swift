//
//  StringLiterals.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/01.
//

import Foundation

enum StringLiterals {
    
    enum Tabbar {
        enum Title {
            static let home = "HOME"
            static let clip = "CLIP"
            static let timer = "TIMER"
            static let my = "MY"
        }
    }
    
    enum BottomSheet {
        enum Placeholder {
            static let addClip = "클립의 이름을 입력해 주세요"
        }
        enum Button {
            static let complete = "확인"
        }
    }
    
    enum Clip {
        enum Title {
            static let addClip = "클립 추가"
            static let emptyLabel = "클립을 추가해 \n 링크를 정리해보세요!"
        }
    }
}

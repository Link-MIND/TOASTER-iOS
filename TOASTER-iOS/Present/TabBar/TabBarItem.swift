//
//  TabBarItem.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/01.
//

import UIKit

enum TabBarItem: CaseIterable {
    
    case home, clip, timer, my

    // 선택되지 않은 탭
    var normalItem: UIImage? {
        switch self {
        case .home:
            return .icHome24.withTintColor(.gray150)
        case .clip:
            return .icClipFull24.withTintColor(.gray150)
        case .timer:
            return .icTimer24.withTintColor(.gray150)
        case .my:
            return .icMy24.withTintColor(.gray150)
        }
    }
    
    // 선택된 탭
    var selectedItem: UIImage? {
        switch self {
        case .home:
            return .icHome24.withTintColor(.black900)
        case .clip:
            return .icClipFull24.withTintColor(.black900)
        case .timer:
            return .icTimer24.withTintColor(.black900)
        case .my:
            return .icMy24.withTintColor(.black900)
        }
    }
    
    // 탭 별 제목
    var itemTitle: String? {
        switch self {
        case .home: return StringLiterals.Tabbar.home
        case .clip: return StringLiterals.Tabbar.clip
        case .timer: return StringLiterals.Tabbar.timer
        case .my: return StringLiterals.Tabbar.my
        }
    }
}

//
//  TabBarItem.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/01.
//

import UIKit

enum TabBarItem: CaseIterable {
    
    case home, clip, plus, timer, my

    // 선택되지 않은 탭
    var normalItem: UIImage? {
        switch self {
        case .home:
            return ImageLiterals.TabBar.home.withTintColor(.gray150)
        case .clip:
            return ImageLiterals.TabBar.clip.withTintColor(.gray150)
        case .plus:
            return ImageLiterals.TabBar.plus
        case .timer:
            return ImageLiterals.TabBar.timer.withTintColor(.gray150)
        case .my:
            return ImageLiterals.TabBar.my.withTintColor(.gray150)
        }
    }
    
    // 선택된 탭
    var selectedItem: UIImage? {
        switch self {
        case .home:
            return ImageLiterals.TabBar.home.withTintColor(.black900)
        case .clip:
            return ImageLiterals.TabBar.clip.withTintColor(.black900)
        case .plus:
            return ImageLiterals.TabBar.plus
        case .timer:
            return ImageLiterals.TabBar.timer.withTintColor(.black900)
        case .my:
            return ImageLiterals.TabBar.my.withTintColor(.black900)
        }
    }
    
    // 탭 별 제목
    var itemTitle: String? {
        switch self {
        case .home: return StringLiterals.Tabbar.Title.home
        case .clip: return StringLiterals.Tabbar.Title.clip
        case .plus: return nil
        case .timer: return StringLiterals.Tabbar.Title.timer
        case .my: return StringLiterals.Tabbar.Title.my
        }
    }
    
    // 탭 별 전환될 화면 -> 나중에 하나씩 추가
    var targetViewController: UIViewController? {
        switch self {
        case .home: return ViewController()
        case .clip: return ClipViewController()
        case .plus: return nil
        case .timer: return nil
        case .my: return nil
        }
    }
    
}

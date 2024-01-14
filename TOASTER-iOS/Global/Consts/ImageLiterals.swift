//
//  ImageLiterals.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/29/23.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - Common
    
    enum Common {
        static var check: UIImage { .load(systemName: "checkmark.circle.fill") }
        static var exclamation: UIImage { .load(systemName: "exclamationmark.circle.fill") }
        static var close: UIImage { .load(name: "ic_close_24") }
        static var arrowLeft: UIImage { .load(name: "ic_arrow_left_24") }
        static var setting: UIImage { .load(name: "ic_settings_24") }
        static var plus: UIImage { .load(name: "ic_plus_24") }
        static var checkRed18: UIImage { .load(name: "ic_check_18") }
        static var rightArrow20: UIImage { .load(name: "ic_arrow_20") }
        static var more: UIImage { .load(name: "ic_more_24") }
    }
    
    // MARK: - TabBar
    
    enum TabBar {
        static var home: UIImage { .load(name: "ic_home_24") }
        static var allClip: UIImage { .load(name: "ic_all_clip_24") }
        static var clip: UIImage { .load(name: "ic_clip_24") }
        static var plus: UIImage { .load(name: "fab_plus") }
        static var timer: UIImage { .load(name: "ic_timer_24") }
        static var my: UIImage { .load(name: "ic_my_24") }
    }
    
    // MARK: - Search
    
    enum Search {
        static var searchIcon: UIImage { .load(name: "ic_search_20") }
        static var searchCancle: UIImage { .load(name: "ic_search_cancle") }
    }
    
    // MARK: - Clip
    
    enum Clip {
        static var rightarrow: UIImage { .load(name: "ic_arrow_18") }
        static var searchbar: UIImage {.load(name: "search_bar") }
        static var orangeplus: UIImage { .load(name: "ic_plus_18_orange") }
        static var meatballs: UIImage { .load(name: "ic_meatballs_24") }
        static var clipEmpty: UIImage { .load(name: "clip_empty") }
        static var detailClipEmpty: UIImage { .load(name: "detail_clip_empty") }
        static var thumb: UIImage { .load(name: "img_thumbnail") }
        static var clipIcon: UIImage { .load(name: "ic_clip_24_black") }
        static var delete: UIImage { .load(name: "ic_delete_28") }
        static var pin: UIImage { .load(name: "ic_pin_24") }
        static var edit: UIImage { .load(name: "ic_edit_24") }
    }
    
    // MARK: - EmptyView
    
    enum EmptyView {
        static var searchEmpty: UIImage { .load(name: "img_search") }
    }
    
    // MARK: - Logo
    
    enum Logo {
        static var wordmark: UIImage { .load(name: "wordmark") }
    }
    
    // MARK: - Login
    
    enum Login {
        static var kakaoLogo: UIImage { .load(name: "ic_kakao_login_24") }
        static var appleLogo: UIImage { .load(name: "ic_apple_login_24") }
    }
    
    enum Remind {
        static var alarmOff: UIImage { .load(name: "img_alarm_ios") }
        static var timerEmpty: UIImage { .load(name: "img_timer") }
        static var alarmDisabled: UIImage { .load(name: "alarm_disabled_20") }
        static var alarmAbled: UIImage { .load(name: "ic_alarm_24") }
    }
    
    // MARK: - Web
    
    enum Web {
        static var backArrow: UIImage { .load(systemName: "arrow.backward") }
        static var forwardArrow: UIImage { .load(systemName: "arrow.forward") }
        static var document: UIImage { .load(systemName: "doc.text.fill") }
        static var safari: UIImage { .load(name: "ic_safari_24") }
        static var reload: UIImage { .load(name: "ic_reload_24") }
    }
    
    // MARK: - Mypage
    
    enum Mypage {
        static var profile: UIImage { .load(name: "profile") }
    }
    
    enum Home {
        static var clipDefault: UIImage { .load(name: "ic_all_clip_24") }
        static var clipFull: UIImage { .load(name: "ic_clip_full_24") }
        static var linkThumbNail: UIImage { .load(name: "img_thumbnail") }
        static var siteThumbNail: UIImage { .load(name: "img_bmsite") }
        static var addBtn: UIImage { .load(name: "btn_plus") }
        static var searchIcon: UIImage { .load(name: "ic_search_20") }
    }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
}

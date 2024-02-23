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
        static var loginLogo: UIImage { .load(name: "img_login") }
        static var loginLogo2: UIImage { .load(name: "img_login2") }
    }
    
    enum Remind {
        static var alarmOff: UIImage { .load(name: "img_alarm_ios") }
        static var timerEmpty: UIImage { .load(name: "img_timer") }
        static var alarmDisabled: UIImage { .load(name: "alarm_disabled_20") }
        static var alarmAbled: UIImage { .load(name: "ic_alarm_24") }
    }
    
    // MARK: - Web
    
    enum Web {
        static var backArrow: UIImage { .load(name: "ic_arrow2_back_24") }
        static var forwardArrow: UIImage { .load(name: "ic_arrow2_forward_24") }
        static var document: UIImage { .load(name: "ic_read") }
        static var safari: UIImage { .load(name: "ic_safari_24") }
        static var reload: UIImage { .load(name: "ic_reload_24") }
    }
    
    // MARK: - Mypage
    
    enum Mypage {
        static var profile: UIImage { .load(name: "profile") }
        static var alarm: UIImage { .load(name: "img_alarm") }
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

//
//  ImageLiterals.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/29/23.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - Normal Icon
    
    enum Common {
        static var check: UIImage { .load(systemName: "checkmark.circle.fill") }
        static var exclamation: UIImage { .load(systemName: "exclamationmark.circle.fill") }
        static var close: UIImage { .load(name: "ic_close_24") }
        static var arrowLeft: UIImage { .load(name: "ic_arrow_left_24") }
        static var setting: UIImage { .load(name: "ic_settings_24") }
        static var plus: UIImage { .load(name: "ic_plus_24") }
    }
    
    enum TabBar {
        static var home: UIImage { .load(name: "ic_home_24") }
        static var clip: UIImage { .load(name: "ic_clip_24") }
        static var plus: UIImage { .load(name: "fab_plus") }
        static var timer: UIImage { .load(name: "ic_timer_24") }
        static var my: UIImage { .load(name: "ic_my_24") }
    }
    
    enum Clip {
        static var rightarrow: UIImage { .load(name: "ic_arrow_18") }
        static var searchbar: UIImage {.load(name: "search_bar") }
        static var orangeplus: UIImage { .load(name: "ic_plus_18_orange") }
        static var meatballs: UIImage { .load(name: "ic_meatballs_24") }
        static var clipEmpty: UIImage { .load(name: "clip_empty") }
        static var detailClipEmpty: UIImage { .load(name: "detail_clip_empty") }
        static var thumb: UIImage { .load(name: "img_thumb") }
    }
    
    enum Logo {
        static var wordmark: UIImage { .load(name: "wordmark") }
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

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

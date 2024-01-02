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
        static var clost: UIImage { .load(name: "ic_close_24") }
    }
    
    enum TabBar {
        static var home: UIImage { .load(name: "ic_home_24") }
        static var clip: UIImage { .load(name: "ic_clip_24") }
        static var plus: UIImage { .load(name: "fab_plus") }
        static var timer: UIImage { .load(name: "ic_timer_24") }
        static var my: UIImage { .load(name: "ic_my_24") }
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

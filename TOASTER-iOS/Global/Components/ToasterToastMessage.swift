//
//  ToasterToastMessage.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/2/24.
//

import UIKit

enum ToastStatus {
    case success, warning, error
    
    var color: UIColor {
        switch self {
        case .success:
            return .toasterSuccess
        case .warning:
            return .toasterWarning
        case .error:
            return .toasterError
        }
    }
}

extension UIViewController {
    
    /// 토스트 메시지를 보여주는 메서드
    func showToastMessage(width: CGFloat, status: ToastStatus, message: String) {
        
        // UI Components
        let toastView = UIView(frame: CGRect(x: view.center.x-width/2, y: view.convertByHeightRatio(668), width: width, height: 46))
        let toastImage = UIImageView()
        let toastLabel = UILabel()
        
        // Style Setup
        toastView.backgroundColor = .gray800
        toastView.makeRounded(radius: 22)
        toastImage.image = ImageLiterals.Common.check
        toastImage.tintColor = status.color
        toastLabel.text = message
        toastLabel.textColor = .toasterWhite
        toastLabel.font = .suitBold(size: 14)

        // Hierarchy Setup
        self.view.addSubview(toastView)
        toastView.addSubviews(toastImage, toastLabel)
        
        // Layout Setup
        toastImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
        toastLabel.snp.makeConstraints {
            $0.leading.equalTo(toastImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: { _ in
            toastView.removeFromSuperview()
        })
    }
}

//
//  ToasterToastMessageView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/3/24.
//

import UIKit

import SnapKit
import Then

final class ToasterToastMessageView: UIView {
    
    // MARK: - UI Components
    
    private let toastImage = UIImageView().then {
        $0.tintColor = .toasterWhite
    }
    
    private let toastLabel = UILabel().then {
        $0.textColor = .toasterWhite
        $0.font = .suitBold(size: 14)
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ToasterToastMessageView {
    func setupDataBind(message: String, status: ToastStatus) {
        toastImage.image = status.icon
        toastLabel.text = message
    }
}

// MARK: - Private Extensions

private extension ToasterToastMessageView {
    func setupStyle() {
        self.backgroundColor = .gray800
        self.makeRounded(radius: 22)
    }
    
    func setupHierarchy() {
        addSubviews(toastImage, toastLabel)
    }
    
    func setupLayout() {
        toastImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
        toastLabel.snp.makeConstraints {
            $0.leading.equalTo(toastImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}

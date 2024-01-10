//
//  LinkWebNavigationView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class LinkWebNavigationView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let popButton = UIButton()
    private let addressLabel = UILabel()
    private let reloadButton = UIButton()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension LinkWebNavigationView {
    func setupLinkAddress(link: String) {
        addressLabel.text = link
    }
}

// MARK: - Private Extensions

private extension LinkWebNavigationView {
    func setupStyle() {
        backgroundColor = .toasterWhite
        
        popButton.do {
            $0.tintColor = .gray800
            $0.setImage(ImageLiterals.Common.arrowLeft, for: .normal)
        }
        
        addressLabel.do {
            $0.font = .suitSemiBold(size: 16)
            $0.textColor = .black900
        }

        reloadButton.do {
            $0.tintColor = .gray800
            $0.setImage(ImageLiterals.Web.reload, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(popButton, addressLabel, reloadButton)
    }
    
    func setupLayout() {
        popButton.snp.makeConstraints {
            $0.size.equalTo(25)
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(6)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(popButton)
            $0.leading.equalTo(popButton.snp.trailing).offset(13)
        }
        
        reloadButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(6)
        }
    }

    func setupAddTarget() {
    
    }
    
    @objc
    func buttonTapped() {
        
    }
}

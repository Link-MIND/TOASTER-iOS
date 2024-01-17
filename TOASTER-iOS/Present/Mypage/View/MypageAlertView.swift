//
//  MypageAlertView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/18/24.
//

import UIKit

import SnapKit
import Then

final class MypageAlertView: UIView {

    // MARK: - UI Components
    
    private let seperatorView = UIView()
    private let alertImage = UIImageView()
    private let alertMessage = UILabel()
    
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

// MARK: - Private Extensions

private extension MypageAlertView {
    func setupStyle() {
        seperatorView.do {
            $0.backgroundColor = .gray50
        }
        
        alertImage.do {
            $0.image = ImageLiterals.Mypage.alarm
            $0.contentMode = .scaleAspectFit
        }
        
        alertMessage.do {
            $0.numberOfLines = 2
            $0.text = "아직 마이페이지는 추가 공사 중! \n 업데이트를 기다려주세요:)"
            $0.textAlignment = .center
            $0.textColor = .gray500
            $0.font = .suitRegular(size: 16)
        }
    }
    
    func setupHierarchy() {
        addSubviews(seperatorView, alertImage, alertMessage)
    }
    
    func setupLayout() {
        seperatorView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        alertImage.snp.makeConstraints {
            $0.top.equalTo(seperatorView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        alertMessage.snp.makeConstraints {
            $0.top.equalTo(alertImage.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}

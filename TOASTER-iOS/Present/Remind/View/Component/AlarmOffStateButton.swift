//
//  AlarmOffStateButton.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class AlarmOffStateButton: UIButton {

    // MARK: - UI Properties
    
    private let titleStackView: UIStackView = UIStackView()
    private let titleIcon: UIImageView = UIImageView(image: .alarmDisabled20)
    private let mainTitleLabel: UILabel = UILabel()
    
    private let nextIcon: UIImageView = UIImageView(image: .icArrow20)
    
    private let subLabel: UILabel = UILabel()
    
    // MARK: - Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension AlarmOffStateButton {
    func setupStyle() {
        backgroundColor = .gray50
        makeRounded(radius: 12)
        
        titleStackView.do {
            $0.spacing = 4
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        mainTitleLabel.do {
            $0.text = "알림 설정이 꺼져 있어요"
            $0.font = .suitBold(size: 18)
            $0.textColor = .gray700
        }
        
        subLabel.do {
            $0.text = "타이머 기능을 이용하시려면\n설정 > 알림에서 알림을 켜주세요"
            $0.font = .suitRegular(size: 16)
            $0.textColor = .gray500
            $0.numberOfLines = 0
            $0.asFontColor(targetString: "설정 > 알림",
                           font: .suitBold(size: 16),
                           color: .gray700)
        }
    }
    
    func setupHierarchy() {
        addSubviews(titleStackView, nextIcon, subLabel)
        titleStackView.addArrangedSubviews(titleIcon, mainTitleLabel)
    }
    
    func setupLayout() {
        titleStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
        }
        
        nextIcon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(4)
            $0.leading.bottom.equalToSuperview().inset(12)
        }
    }
}

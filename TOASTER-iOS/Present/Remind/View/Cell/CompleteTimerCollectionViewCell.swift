//
//  CompleteTimerCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class CompleteTimerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
        
    private let timeStackView: UIStackView = UIStackView()
    private let alarmIcon: UIImageView = UIImageView(image: .icAlarm24)
    private let timeLabel: UILabel = UILabel()
    
    private let toReadView: UIView = UIView()
    private let toReadLabel: UILabel = UILabel()
    
    private let subLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
        
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

// MARK: - Extension

extension CompleteTimerCollectionViewCell {
    func configureCell(forModel: CompleteTimerModel) {
        timeLabel.text = "\(forModel.remindDay) \(forModel.remindTime)"
        subLabel.text = "\(forModel.clipName) 링크들을 \n읽기 딱 좋은 시간이에요!"
        subLabel.asFontColor(targetString: forModel.clipName, font: .suitSemiBold(size: 16), color: .gray800)
    }
}

// MARK: - Private Extension

private extension CompleteTimerCollectionViewCell {
    func setupStyle() {
        backgroundColor = .toasterWhite
        makeRounded(radius: 12)
        
        timeStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
        }
        
        timeLabel.do {
            $0.font = .suitBold(size: 18)
            $0.textColor = .black900
        }
        
        toReadView.do {
            $0.backgroundColor = .toaster100
            $0.makeRounded(radius: 4)
        }
        
        toReadLabel.do {
            $0.text = "읽으러가기"
            $0.font = .suitSemiBold(size: 14)
            $0.textColor = .toasterPrimary
        }
        
        subLabel.do {
            $0.text = "링크들을 \n읽기 딱 좋은 시간이에요!"
            $0.font = .suitRegular(size: 16)
            $0.textColor = .gray600
            $0.numberOfLines = 0
        }
    }
    
    func setupHierarchy() {
        addSubviews(timeStackView, toReadView, subLabel)
        timeStackView.addArrangedSubviews(alarmIcon, timeLabel)
        toReadView.addSubview(toReadLabel)
    }
    
    func setupLayout() {
        timeStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
            $0.trailing.equalTo(toReadView.snp.leading).offset(-14)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview().inset(14)
        }
        
        toReadView.snp.makeConstraints {
            $0.width.equalTo(86)
            $0.height.equalTo(25)
            $0.top.trailing.equalToSuperview().inset(14)
        }
        
        toReadLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        alarmIcon.snp.makeConstraints {
            $0.height.width.equalTo(24)
        }
    }
}

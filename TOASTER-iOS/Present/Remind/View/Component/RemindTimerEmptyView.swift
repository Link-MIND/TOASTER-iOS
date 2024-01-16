//
//  RemindTimerEmptyView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class RemindTimerEmptyView: UIView {

    // MARK: - Properties
    
    typealias SettingButtonAction = () -> Void
    private var settingButtonAction: SettingButtonAction?

    // MARK: - UI Properties
    
    private let emptyImageView: UIImageView = UIImageView()
    private let emptyLabel: UILabel = UILabel()
    private let emptySubLabel: UILabel = UILabel()
    private let settingTimerButton: UIButton = UIButton()
    
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

// MARK: - Extension

extension RemindTimerEmptyView {
    func setupButtonEnable(forEnable: Bool) {
        settingTimerButton.isEnabled = forEnable
        switch forEnable {
        case true: 
            settingTimerButton.backgroundColor = .toasterBlack
            settingTimerButton.snp.updateConstraints {
                $0.width.equalTo(142)
            }
        case false:
            settingTimerButton.backgroundColor = .gray200
            settingTimerButton.snp.updateConstraints {
                $0.width.equalTo(191)
            }
        }
    }
    
    func setupButtonAction(action: @escaping SettingButtonAction) {
        settingButtonAction = action
    }
}

// MARK: - Private Extension

private extension RemindTimerEmptyView {
    func setupStyle() {
        backgroundColor = .clear
        
        emptyImageView.do {
            $0.image = ImageLiterals.Remind.timerEmpty
        }
        
        emptyLabel.do {
            $0.numberOfLines = 0
            $0.textColor = .gray500
            $0.textAlignment = .center
            $0.font = .suitRegular(size: 16)
            $0.text = "타이머를 설정하고\n원하는 때에 링크를 받아보세요"
        }
        
        emptySubLabel.do {
            $0.textColor = .gray300
            $0.textAlignment = .center
            $0.font = .suitMedium(size: 14)
            $0.text = "* 알림 설정이 꺼져있을 시 타이머 기능이 제한돼요"
        }
        
        settingTimerButton.do {
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .toasterBlack
            $0.setTitle("타이머 설정하기", for: .normal)
            $0.setTitle("지금은 설정할 수 없어요", for: .disabled)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
            $0.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(emptyImageView, emptyLabel, settingTimerButton)
    }
    
    func setupLayout() {
        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(convertByWidthRatio(200))
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
        }
        
        settingTimerButton.snp.makeConstraints {
            $0.width.equalTo(142)
            $0.height.equalTo(44)
            $0.centerX.bottom.equalToSuperview()
            $0.top.equalTo(emptyLabel.snp.bottom).offset(12)
        }
    }
    
    @objc func settingButtonTapped() {
        settingButtonAction?()
    }
}

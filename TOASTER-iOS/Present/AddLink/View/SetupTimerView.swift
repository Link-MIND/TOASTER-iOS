//
//  SetupTimerView.swift
//  TOASTER-iOS
//
//  Created by 민 on 8/28/25.
//

import UIKit

import SnapKit

final class SetupTimerView: UIView {
    
    // MARK: - Properties
    
    private var switchValueChangedHandler: ((Bool) -> Void)?
    private var isTimerOn: Bool = false {
        didSet {
            timerDescriptionLabel.text = isTimerOn
            ? "7일간 열람하지 않으면 사라져요"
            : "링크가 영구 저장돼요"
        }
    }
    
    // MARK: - UI Components
    
    private let seperatorView = UIView()
    private let timerTitleLabel = UILabel()
    private let timerDesctiptionStackView = UIStackView()
    private let timerDescriptionIcon = UIImageView()
    private let timerDescriptionLabel = UILabel()
    private let timerSettingSwitch = UISwitch()
    
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

extension SetupTimerView {
    func setupDataBind() {
        
    }
    
    func setSwitchValueChangedHandler(_ handler: @escaping (Bool) -> Void) {
        switchValueChangedHandler = handler
    }
}

// MARK: - Private Extensions

private extension SetupTimerView {
    func setupStyle() {
        seperatorView.do {
            $0.backgroundColor = .gray50
        }
        
        timerTitleLabel.do {
            $0.text = "타이머"
            $0.font = .suitMedium(size: 18)
            $0.textColor = .black900
        }
        
        timerDesctiptionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .center
        }
        
        timerDescriptionIcon.do {
            $0.image = .icAlert18Dark
            $0.contentMode = .scaleAspectFit
        }
        
        timerDescriptionLabel.do {
            $0.text = "링크가 영구 저장돼요"
            $0.font = .suitMedium(size: 13)
            $0.textColor = .gray400
        }
        
        timerSettingSwitch.do {
            $0.onTintColor = .toasterPrimary
            $0.isOn = isTimerOn
            $0.isUserInteractionEnabled = true
            $0.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            seperatorView,
            timerTitleLabel,
            timerDesctiptionStackView,
            timerSettingSwitch
        )
        
        timerDesctiptionStackView.addArrangedSubviews(timerDescriptionIcon)
        timerDesctiptionStackView.addArrangedSubview(timerDescriptionLabel)
    }
    
    func setupLayout() {
        seperatorView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        timerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(seperatorView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        timerDesctiptionStackView.snp.makeConstraints {
            $0.leading.equalTo(timerTitleLabel.snp.trailing).offset(12)
            $0.centerY.equalTo(timerTitleLabel)
        }
        
        timerDescriptionIcon.snp.makeConstraints {
            $0.size.equalTo(14)
        }
        
        timerSettingSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalTo(timerTitleLabel)
            $0.width.equalTo(40)
            $0.height.equalTo(24)
        }
    }
    
    @objc
    func switchValueChanged(_ sender: UISwitch) {
        isTimerOn = sender.isOn
        switchValueChangedHandler?(sender.isOn)
    }
}

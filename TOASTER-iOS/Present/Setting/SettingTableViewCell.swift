//
//  SettingTableViewCell.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var switchValueChangedHandler: ((Bool) -> Void)?
    
    // MARK: - UI Components
    
    private let settingLabel = UILabel()
    private let settingSwitch = UISwitch()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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

extension SettingTableViewCell {
    func configureCell(name: String, sectionNumber: Int) {
        switch sectionNumber {
        case 0:
            settingLabel.do {
                $0.text = "\(name)님"
                $0.font = .suitMedium(size: 18)
                $0.asFont(targetString: name, font: .suitBold(size: 18))
                $0.textColor = .black900
            }
        case 1:
            settingLabel.do {
                $0.text = name
                $0.font = .suitMedium(size: 18)
                $0.textColor = .black900
            }
        default:
            settingLabel.do {
                $0.text = name
                $0.font = .suitMedium(size: 16)
                $0.textColor = .gray400
            }
        }
    }
    
    func showSwitch() {
        settingSwitch.isHidden = false
    }
    
    func setSwitchValueChangedHandler(_ handler: @escaping (Bool) -> Void) {
        switchValueChangedHandler = handler
    }
}

// MARK: - Private Extensions

private extension SettingTableViewCell {
    func setupStyle() {
        backgroundColor = .toasterBackground
        settingSwitch.isHidden = true
        
        settingSwitch.do {
            $0.isOn = false
            $0.isUserInteractionEnabled = true
            $0.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(settingLabel, settingSwitch)
    }
    
    func setupLayout() {
        settingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        settingSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(24)
        }
    }
    
    @objc
    func switchValueChanged(_ sender: UISwitch) {
        switchValueChangedHandler?(sender.isOn)
    }
}

//
//  WaitTimerCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class WaitTimerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    typealias EditButtonAction = (Int?) -> Void
    private var editButtonAction: EditButtonAction?
    private var editTimerID: Int?

    // MARK: - UI Properties
        
    private let infoStackView: UIStackView = UIStackView()
    private let clipLabel: UILabel = UILabel()
    private let timeLabel: UILabel = UILabel()
    
    private let toggleSwitch: UISwitch = UISwitch()
    
    private let divideLine: UIView = UIView()
    private let editButton: UIButton = UIButton()
    
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

extension WaitTimerCollectionViewCell {
    func configureCell(forModel: WaitTimerModel,
                       forAction: @escaping EditButtonAction) {
        clipLabel.text = "\(forModel.clipName)"
        timeLabel.text = "매주 \(forModel.remindDay) \(forModel.remindTime)마다"
        toggleSwitch.isOn = forModel.isEnable
        editButtonAction = forAction
        editTimerID = forModel.id
    }
}

// MARK: - Private Extension

private extension WaitTimerCollectionViewCell {
    func setupStyle() {
        backgroundColor = .gray50
        makeRounded(radius: 12)
        
        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .leading
        }
        
        clipLabel.do {
            $0.font = .suitSemiBold(size: 14)
            $0.textColor = .gray400
        }
        
        timeLabel.do {
            $0.text = "매주"
            $0.font = .suitBold(size: 16)
            $0.textColor = .gray800
        }
        
        toggleSwitch.do {
            $0.onTintColor = .toasterPrimary
        }
        
        divideLine.do {
            $0.backgroundColor = .gray100
        }
        
        editButton.do {
            $0.setImage(ImageLiterals.Common.more, for: .normal)
            $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(infoStackView, toggleSwitch, divideLine, editButton)
        infoStackView.addArrangedSubviews(clipLabel, timeLabel)
    }
    
    func setupLayout() {
        infoStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
        }
        
        toggleSwitch.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(14)
        }
        
        divideLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(infoStackView.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(6)
        }
    }
    
    @objc func editButtonTapped() {
        editButtonAction?(editTimerID)
    }
}

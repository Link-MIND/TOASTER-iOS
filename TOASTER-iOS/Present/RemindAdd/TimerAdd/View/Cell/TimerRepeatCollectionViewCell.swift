//
//  TimerRepeatCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

final class TimerRepeatCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let repeatLabel: UILabel = UILabel()
    private let checkImageView: UIImageView = UIImageView(image: .icCheck18)
    
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

extension TimerRepeatCollectionViewCell {
    func configureCell(forModel: TimerRepeatDate) {
        repeatLabel.text = forModel.name
    }
    
    func cellSelected(forSelect: Bool) {
        if forSelect {
            repeatLabel.textColor = .toasterPrimary
            repeatLabel.font = .suitBold(size: 16)
            checkImageView.isHidden = false
        } else {
            repeatLabel.textColor = .black900
            repeatLabel.font = .suitMedium(size: 16)
            checkImageView.isHidden = true
        }
    }
}

// MARK: - Private Extension

private extension TimerRepeatCollectionViewCell {
    func setupStyle() {
        backgroundColor = .white
        
        repeatLabel.do {
            $0.textColor = .black900
            $0.font = .suitMedium(size: 16)
        }
        
        checkImageView.do {
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        addSubviews(repeatLabel, checkImageView)
    }
    
    func setupLayout() {
        repeatLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

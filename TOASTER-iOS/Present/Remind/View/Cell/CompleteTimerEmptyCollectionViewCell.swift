//
//  CompleteTimerEmptyCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class CompleteTimerEmptyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
        
    private let explainLabel: UILabel = UILabel()
    
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

// MARK: - Private Extension

private extension CompleteTimerEmptyCollectionViewCell {
    func setupStyle() {
        backgroundColor = .gray50
        makeRounded(radius: 12)
        
        explainLabel.do {
            $0.textColor = .gray400
            $0.font = .suitRegular(size: 16)
            $0.text = "타이머가 완료되면 리마인드 드릴게요"
        }
    }
    
    func setupHierarchy() {
        addSubview(explainLabel)
    }
    
    func setupLayout() {
        explainLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

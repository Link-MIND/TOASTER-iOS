//
//  WeeklyLinkCollectionReusableView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import UIKit

import SnapKit
import Then

// MARK: - 이주의 링크 header

final class WeeklyLinkHeaderCollectionView: UICollectionReusableView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - set up Style
    
    private func setupStyle() {
        titleLabel.do {
            $0.textColor = .black900
            $0.font = .suitMedium(size: 18)
            $0.text = StringLiterals.Home.WeeklyLinkHeader.weeklyLinkLabel
        }
    }
    
    // MARK: - set up Hierarchy
    
    private func setupHierarchy() {
        addSubview(titleLabel)
    }
    
    // MARK: - set up Layout
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
}

//
//  UserClipEmptyCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/11.
//

import UIKit

import SnapKit
import Then

final class UserClipEmptyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let addClipImage = UIImageView()
    private let addClipLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Make View
    
    func setView() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

// MARK: - Private Extensions

private extension UserClipEmptyCollectionViewCell {
    func setupStyle() {
        backgroundColor = .clear
        self.makeRounded(radius: 12)
        
        addClipImage.do {
            $0.image = ImageLiterals.Home.addBtn
        }
        
        addClipLabel.do {
            $0.font = .suitBold(size: 14)
            $0.textColor = .gray200
            $0.text = "클립 추가"
        }
    }
    
    func setupHierarchy() {
        addSubviews(addClipImage, addClipLabel)
    }
    
    func setupLayout() {
        addClipImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(34)
            $0.size.equalTo(42)
        }
        
        addClipLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(addClipImage.snp.bottom).offset(1)
        }
    }
    
}

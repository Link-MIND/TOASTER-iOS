//
//  UserClipCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import UIKit

import SnapKit
import Then

// MARK: - 사용자의 클립

final class UserClipCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let clipImage = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
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

extension UserClipCollectionViewCell {
    func configureCell(forModel: ToastList) {
        titleLabel.text = forModel.toastTitle
        countLabel.text = forModel.linkURL
    }
}

// MARK: - Private Extensions

private extension UserClipCollectionViewCell {
    
    func setupStyle() {
        backgroundColor = .toasterWhite
        self.makeRounded(radius: 12)
        
        clipImage.do {
            $0.image = ImageLiterals.Home.clipFull
        }
        
        titleLabel.do {
            $0.text = "전체 클립"
            $0.font = .suitSemiBold(size: 16)
            $0.textColor = .black900
        }
        
        countLabel.do {
            $0.text = "n개"
            $0.font = .suitBold(size: 14)
            $0.textColor = .gray700
        }
    }
    
    func setupHierarchy() {
        addSubviews(clipImage, titleLabel, countLabel)
    }
    
    func setupLayout() {
        clipImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(clipImage.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(12)
        }
    }
}

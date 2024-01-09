//
//  ClipListCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class ClipListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let clipImage = UIImageView()
    private let clipNameLabel = UILabel()
    private let countLabel = UILabel()
    private let arrowImage = UIImageView()
    
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

// MARK: - Extensions

extension ClipListCollectionViewCell {
    func configureCell(forModel: ClipListModel, icon: UIImage) {
        clipNameLabel.text = forModel.categoryTitle
        countLabel.text = "\(forModel.toastNum)개"
        clipImage.image = icon
    }
}

// MARK: - Private Extensions

private extension ClipListCollectionViewCell {
    func setupStyle() {
        self.backgroundColor = .toasterWhite
        self.makeRounded(radius: 12)
        
        clipNameLabel.do {
            $0.font = .suitSemiBold(size: 16)
            $0.textColor = .black850
        }
        
        countLabel.do {
            $0.font = .suitSemiBold(size: 14)
            $0.textColor = .gray600
        }
        
        arrowImage.do {
            $0.image = ImageLiterals.Clip.rightarrow
        }
    }
    
    func setupHierarchy() {
        addSubviews(clipImage, clipNameLabel, countLabel, arrowImage)
    }
    
    func setupLayout() {
        clipImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
            $0.size.equalTo(24)
        }
        
        clipNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(clipImage)
            $0.leading.equalTo(clipImage.snp.trailing).offset(4)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalTo(clipImage)
            $0.trailing.equalTo(arrowImage.snp.leading).inset(2)
        }
        
        arrowImage.snp.makeConstraints {
            $0.centerY.equalTo(clipImage)
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(20)
        }
    }
}

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
    
    // MARK: - Properties
    
    static let identifier: String = "ClipListCollectionViewCell"
    
    // MARK: - UI Components
    
    private let clipImage = UIImageView().then {
        $0.image = ImageLiterals.TabBar.clip.withTintColor(.black900)
    }
    
    private let clipNameLabel = UILabel().then {
        $0.font = .suitSemiBold(size: 16)
        $0.textColor = .black850
    }
    
    private let countLabel = UILabel().then {
        $0.font = .suitSemiBold(size: 14)
        $0.textColor = .gray600
    }
    
    private let arrowImage = UIImageView().then {
        $0.image = ImageLiterals.Clip.rightarrow
    }
    
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
    func configureCell(forModel: ClipListModel) {
        clipNameLabel.text = forModel.categoryTitle
        countLabel.text = "\(forModel.toastNum)개"
    }
}

// MARK: - Private Extensions

private extension ClipListCollectionViewCell {
    func setupStyle() {
        backgroundColor = .toasterWhite
        makeRounded(radius: 12)
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

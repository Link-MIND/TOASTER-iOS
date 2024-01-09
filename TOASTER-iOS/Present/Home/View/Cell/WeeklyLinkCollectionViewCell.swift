//
//  WeeklyLinkCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import UIKit

import SnapKit
import Then

// MARK: - 이주의 링크

final class WeeklyLinkCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let linkImage = UIImageView()
    private let linkTitleLabel = UILabel()
    private let linkLabel = UILabel()
    
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

// MARK: - Private extensions

private extension WeeklyLinkCollectionViewCell {

    func setupStyle() {
        backgroundColor = .toasterWhite
        self.makeRounded(radius: 12)
        
        linkImage.do {
            $0.makeRounded(radius: 8)
            $0.image = ImageLiterals.Home.linkThumbNail
        }
        
        linkTitleLabel.do {
            $0.text = "Title"
            $0.font = .suitMedium(size: 16)
            $0.textColor = .black900
        }
        
        linkLabel.do {
            $0.text = "https://myApple.com"
            $0.font = .suitRegular(size: 10)
            $0.textColor = .gray200
        }
    }
    
    func setupHierarchy() {
        addSubviews(linkImage, linkTitleLabel, linkLabel)
    }
    
    func setupLayout() {
        linkImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(74)
        }
        
        linkTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(linkImage.snp.trailing).offset(12)
        }
        
        linkLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(12)
            $0.leading.equalTo(linkImage.snp.trailing).offset(12)
        }
    }
}

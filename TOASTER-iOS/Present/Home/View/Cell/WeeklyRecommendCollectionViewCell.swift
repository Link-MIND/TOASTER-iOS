//
//  WeeklyRecommendCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import UIKit

import SnapKit
import Then
import Kingfisher

// MARK: - 이주의 추천 사이트

final class WeeklyRecommendCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let brandImage = UIImageView()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    
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

extension WeeklyRecommendCollectionViewCell {
    func bindData(forModel: RecommendSiteModel) {
        brandImage.kf.setImage(with: URL(string: forModel.siteImg ?? ""))
        titleLabel.text = forModel.siteTitle
        subLabel.text = forModel.siteSub
    }
}

// MARK: - Private Extensions

private extension WeeklyRecommendCollectionViewCell {
    
    func setupStyle() {
        backgroundColor = .toasterWhite
        self.makeRounded(radius: 8)
        
        brandImage.do {
            $0.image = ImageLiterals.Home.siteThumbNail
        }
        
        titleLabel.do {
            $0.text = "Title" // 서버 통신 이후 dummyData로 뺄 것
            $0.font = .suitBold(size: 12)
            $0.textColor = .gray800
        }
        
        subLabel.do {
            $0.text = "sub" // 서버 통신 이후 dummyData로 뺄 것
            $0.font = .suitMedium(size: 10)
            $0.textColor = .gray400
        }
    }
    
    func setupHierarchy() {
        addSubviews(brandImage, titleLabel, subLabel)
    }
    
    func setupLayout() {
        brandImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(brandImage.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }
}

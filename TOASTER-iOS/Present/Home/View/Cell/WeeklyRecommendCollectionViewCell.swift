//
//  WeeklyRecommendCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import UIKit

import SnapKit
import Then

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


private extension WeeklyRecommendCollectionViewCell {
    
    func setupStyle() {

    }
    
    func setupHierarchy() {
        
    }
    
    func setupLayout() {
        
    }
}

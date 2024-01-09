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
    
    private let clipStackView = UIStackView()
    
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


private extension UserClipCollectionViewCell {
    
    func setupStyle() {
        contentView.backgroundColor = .lightGray
        clipImage.do {
            $0.image = UIImage(systemName: "folder")?.withTintColor(.black)
        }
        
        titleLabel.do {
            $0.text = "전체 클립"
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textColor = .black
        }
        
        countLabel.do {
            $0.text = "n개"
            $0.font = .boldSystemFont(ofSize: 14)
        }
        
        clipStackView.do {
            $0.distribution = .equalSpacing
            $0.axis = .vertical
        }
    }
    
    func setupHierarchy() {
        
        
    }
    
    func setupLayout() {
        
    }
}

//
//  ClipEmptyView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/5/24.
//

import UIKit

import SnapKit
import Then

final class ClipEmptyView: UIView {
    
    // MARK: - UI Components
    
    private let emptyImage = UIImageView()
    private let emptyLabel = UILabel()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension ClipEmptyView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        emptyImage.do {
            $0.image = ImageLiterals.Clip.clipEmpty
        }
        
        emptyLabel.do {
            $0.text = StringLiterals.Clip.Title.emptyLabel
            $0.numberOfLines = 2
            $0.textColor = .gray500
            $0.font = .suitRegular(size: 16)
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        addSubviews(emptyImage, emptyLabel)
    }
    
    func setupLayout() {
        emptyImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.size.equalTo(200)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(emptyImage.snp.bottom)
        }
    }
}

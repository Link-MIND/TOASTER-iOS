//
//  ClipCollectionHeaderView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class ClipCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "ClipCollectionHeaderView"
    
    // MARK: - UI Components
    
    private let clipCountLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = .suitBold(size: 12)
        $0.text = "전체 (n)"
    }
    
    private let addClipButton = UIButton().then {
        $0.setImage(ImageLiterals.Clip.orangeplus, for: .normal)
        $0.setTitle(StringLiterals.Clip.Title.addClip, for: .normal)
        $0.setTitleColor(.toasterPrimary, for: .normal)
        $0.titleLabel?.font = .suitBold(size: 12)
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ClipCollectionHeaderView {
    func setupDataBind() {
        
    }
}

// MARK: - Private Extensions

private extension ClipCollectionHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
    }
    
    func setupHierarchy() {
        addSubviews(clipCountLabel, addClipButton)
    }
    
    func setupLayout() {
        clipCountLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        addClipButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupAddTarget() {
        
    }
    
    @objc
    func buttonTapped() {
        
    }
}


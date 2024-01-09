//
//  MainFooterCollectionReusableView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//

import UIKit

import SnapKit
import Then

// MARK: - Main footer

final class MainFooterCollectionReusableView: UICollectionReusableView {

    // MARK: - Properties
    
    private let divideView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - set up Style
    
    private func setupStyle() {
        divideView.do {
            $0.backgroundColor = .gray50
        }
    }
    
    // MARK: - set up Hierarchy
    
    private func setupHierarchy() {
        addSubview(divideView)
    }
    
    // MARK: - set up Layout
    
    private func setupLayout() {
        divideView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(7)
            $0.width.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
}

//
//  WeeklyLinkFooterCollectionReusableView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/10.
//

import UIKit

import SnapKit
import Then

final class WeeklyLinkFooterCollectionReusableView: UICollectionReusableView {
    
    private let divideView = UIView()
    
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
    
    private func setupStyle() {
        divideView.do {
            $0.backgroundColor = .gray50
        }

    }
    
    private func setupHierarchy() {
        addSubview(divideView)
    }
    
    private func setupLayout() {
        divideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

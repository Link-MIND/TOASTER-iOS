//
//  SearchEmptyResultView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/9/24.
//

import UIKit

import SnapKit
import Then

final class SearchEmptyResultView: UIView {

    // MARK: - UI Components
    
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    
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

private extension SearchEmptyResultView {
    func setupStyle() {
        backgroundColor = .clear
        
        emptyImageView.do {
            $0.image = ImageLiterals.EmptyView.searchEmpty
        }
        
        emptyLabel.do {
            $0.textColor = .gray500
            $0.textAlignment = .center
            $0.font = .suitRegular(size: 16)
            $0.text = "검색 결과가 없어요\n다른 검색어로 찾아보실래요?"
        }
    }
    
    func setupHierarchy() {
        addSubviews(emptyImageView, emptyLabel)
    }
    
    func setupLayout() {
        emptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(convertByWidthRatio(200))
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
}

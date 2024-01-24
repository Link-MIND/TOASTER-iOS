//
//  SelectClipHeaderView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/15.
//

import UIKit

import SnapKit
import Then

protocol SelectClipHeaderViewlDelegate: AnyObject {
    func addClipCellTapped()
}

final class SelectClipHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var selectClipHeaderViewDelegate: SelectClipHeaderViewlDelegate?

    // MARK: - UI Properties
    
    private let desciptLabel = UILabel()
    private let totalCountLabel = UILabel()
    private let addClipButton = UIButton()
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupView() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectClipHeaderView {
    func bindData(count: Int) {
        totalCountLabel.text = "전체 (\(count))"
    }
}

// MARK: - Private Extension

private extension SelectClipHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
    
        desciptLabel.do {
            $0.text = "클립을 선택해주세요"
            $0.textColor = .black900
            $0.font = .suitMedium(size: 18)
        }
        
        totalCountLabel.do {
            $0.textColor = .gray500
            $0.font = .suitBold(size: 12)
        }
        
        addClipButton.do {
            $0.setImage(ImageLiterals.Clip.orangeplus, for: .normal)
            $0.setTitle("클립 추가", for: .normal)
            $0.setTitleColor(.toasterPrimary, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 12)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(desciptLabel, totalCountLabel, addClipButton)
    }
    
    func setupLayout() {
        desciptLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaInsets)
            $0.leading.equalToSuperview().inset(20)
        }
        
        totalCountLabel.snp.makeConstraints {
            $0.top.equalTo(desciptLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        addClipButton.snp.makeConstraints {
            $0.top.equalTo(desciptLabel.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    @objc func buttonTapped() {
        selectClipHeaderViewDelegate?.addClipCellTapped()
    }
}

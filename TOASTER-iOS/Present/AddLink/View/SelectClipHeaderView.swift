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
    private let clipToggleControl = ToasterPillToggleControl()
    private let addClipButton = UIButton()
    
    // MARK: - Life Cycle
    
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

extension SelectClipHeaderView {
    func bindData(count: Int) {
        // TODO: - 클립 카운트 값 공유 클립도 추후 바인딩 되도록 수정필요
        clipToggleControl.setupTitles(
            first: "내 클립(\(count))",
            second: "공유 클립(\(0))"
        )
    }
}

// MARK: - Private Extension

private extension SelectClipHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        desciptLabel.do {
            $0.text = "클립 선택"
            $0.textColor = .black900
            $0.font = .suitMedium(size: 18)
        }
        
        addClipButton.do {
            $0.setImage(.icPlus18Orange, for: .normal)
            $0.setTitle("클립 추가", for: .normal)
            $0.setTitleColor(.toasterPrimary, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 12)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            desciptLabel,
            clipToggleControl,
            addClipButton
        )
    }
    
    func setupLayout() {
        desciptLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        clipToggleControl.snp.makeConstraints {
            $0.top.equalTo(desciptLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        addClipButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(clipToggleControl)
        }
    }
    
    @objc func buttonTapped() {
        selectClipHeaderViewDelegate?.addClipCellTapped()
    }
}

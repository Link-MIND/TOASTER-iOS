//
//  EditClipNoticeView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class EditClipNoticeView: UIView {

    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let noticeLabel = UILabel()
    
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

private extension EditClipNoticeView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        backgroundView.do {
            $0.backgroundColor = .gray50
            $0.makeRounded(radius: 12)
        }
        
        noticeLabel.do {
            $0.text = "클립을 누른 뒤 위아래로 드래그하여 순서를 수정할 수 있어요!"
            $0.font = .suitSemiBold(size: 12)
            $0.textColor = .gray400
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(noticeLabel)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

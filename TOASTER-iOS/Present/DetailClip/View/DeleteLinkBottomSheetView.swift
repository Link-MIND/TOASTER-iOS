//
//  DeleteLinkBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/7/24.
//

import UIKit

import SnapKit
import Then

final class DeleteLinkBottomSheetView: UIView {
    
    // MARK: - Properties
    
    var deleteLinkBottomSheetViewButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let deleteButton = UIButton()
    
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

// MARK: - Private Extensions

private extension DeleteLinkBottomSheetView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        deleteButton.do {
            $0.setTitle("삭제", for: .normal)
            $0.backgroundColor = .toasterWhite
            $0.setTitleColor(.toasterPrimary, for: .normal)
            $0.titleLabel?.font = .suitMedium(size: 16)
            $0.contentHorizontalAlignment = .left
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            $0.makeRounded(radius: 12)
        }
    }
    
    func setupHierarchy() {
        addSubviews(deleteButton)
    }
    
    func setupLayout() {
        deleteButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.height.equalTo(54)
        }
    }
    
    func setupAddTarget() {
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    func buttonTapped() {
        deleteLinkBottomSheetViewButtonAction?()
    }
}

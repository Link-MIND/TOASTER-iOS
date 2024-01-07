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
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .toasterWhite
            configuration.baseForegroundColor = .toasterPrimary
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            var titleContainer = AttributeContainer()
            titleContainer.font = UIFont.suitMedium(size: 16)
            configuration.attributedTitle = AttributedString(StringLiterals.BottomSheet.Button.delete, attributes: titleContainer)
            
            $0.configuration = configuration
            $0.makeRounded(radius: 12)
            $0.contentHorizontalAlignment = .leading
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

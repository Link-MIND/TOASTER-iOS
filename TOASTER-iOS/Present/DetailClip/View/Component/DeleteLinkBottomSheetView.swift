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
    
    private var deleteLinkBottomSheetViewButtonAction: (() -> Void)?
    private var editLinkTitleBottomSheetViewButtonAction: (() -> Void)?
    private var confirmBottomSheetViewButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let deleteButton = UIButton()
    private let editButton = UIButton()
    
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

extension DeleteLinkBottomSheetView {
    func setupDeleteLinkBottomSheetButtonAction(_ action: (() -> Void)?) {
        deleteLinkBottomSheetViewButtonAction = action
    }
    
    func setupEditLinkTitleBottomSheetButtonAction(_ action: (() -> Void)?) {
        editLinkTitleBottomSheetViewButtonAction = action
    }
    
    func setupConfirmBottomSheetButtonAction(_ action: (() -> Void)?) {
        confirmBottomSheetViewButtonAction = action
    }
}

// MARK: - Private Extensions

private extension DeleteLinkBottomSheetView {
    func setupStyle() {
        backgroundColor = .gray50
        
        editButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .toasterWhite
            configuration.baseForegroundColor = .black900
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            var titleContainer = AttributeContainer()
            titleContainer.font = UIFont.suitMedium(size: 16)
            configuration.attributedTitle = AttributedString(StringLiterals.Button.editTitle, attributes: titleContainer)
            
            $0.configuration = configuration
            $0.makeRounded(radius: 12)
            $0.contentHorizontalAlignment = .leading
        }
        
        deleteButton.do {
            var configuration = UIButton.Configuration.filled()
            configuration.baseBackgroundColor = .toasterWhite
            configuration.baseForegroundColor = .toasterPrimary
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            var titleContainer = AttributeContainer()
            titleContainer.font = UIFont.suitMedium(size: 16)
            configuration.attributedTitle = AttributedString(StringLiterals.Button.delete, attributes: titleContainer)
            
            $0.configuration = configuration
            $0.makeRounded(radius: 12)
            $0.contentHorizontalAlignment = .leading
        }
    }
    
    func setupHierarchy() {
        addSubviews(editButton, deleteButton)
    }
    
    func setupLayout() {
        editButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(editButton.snp.bottom).inset(5)
            $0.height.equalTo(54)
        }
    }
    
    func setupAddTarget() {
        editButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        switch sender {
        case editButton:
            editLinkTitleBottomSheetViewButtonAction?()
        case deleteButton:
            deleteLinkBottomSheetViewButtonAction?()
        default:
            break
        }
    }
}

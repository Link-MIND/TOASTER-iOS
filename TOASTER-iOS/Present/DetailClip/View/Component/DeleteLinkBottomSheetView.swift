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
    private let deleteButtonLabel = UILabel()
    private let editButtonLabel = UILabel()
    
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
            $0.backgroundColor = .toasterWhite
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.makeRounded(radius: 12)
        }
        
        deleteButton.do {
            $0.backgroundColor = .toasterWhite
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.makeRounded(radius: 12)
        }
        
        editButtonLabel.do {
            $0.text = "수정하기"
            $0.textColor = .black900
            $0.font = .suitMedium(size: 16)
        }
        
        deleteButtonLabel.do {
            $0.text = StringLiterals.Button.delete
            $0.textColor = .toasterError
            $0.font = .suitMedium(size: 16)
        }
    }
    
    func setupHierarchy() {
        addSubviews(editButton, deleteButton)
        editButton.addSubview(editButtonLabel)
        deleteButton.addSubview(deleteButtonLabel)
    }
    
    func setupLayout() {
        editButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(editButton.snp.bottom).offset(1)
            $0.height.equalTo(54)
        }
        
        [editButtonLabel, deleteButtonLabel].forEach {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
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

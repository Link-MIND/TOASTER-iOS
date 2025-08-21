//
//  AddLinkBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 민 on 8/11/25.
//

import UIKit

import SnapKit

final class AddLinkBottomSheetView: UIView {
    
    // MARK: - Properties
    
    private var isButtonClicked: Bool = true {
        didSet {
            setupButtonColor()
        }
    }
    
    // MARK: - UI Components
    
    private let linkEmbedTextField = UITextField()
    private let clearButton = UIButton()
    
    private let completeButton = UIButton()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension AddLinkBottomSheetView {
    func setupDataBind() {
        
    }
}

// MARK: - Private Extensions

private extension AddLinkBottomSheetView {
    func setupStyle() {
        linkEmbedTextField.do {
            $0.placeholder = StringLiterals.Placeholder.copyLink
            $0.tintColor = .toasterPrimary
            $0.backgroundColor = .gray50
            $0.makeRounded(radius: 12)
            $0.addPadding(left: 14, right: 42)
            //$0.addTarget(self, action: #selector(self.textFieldDidChange), for: .touchUpInside)
        }
        
        clearButton.do {
            $0.setImage(.icCancle24, for: .normal)
//            $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            $0.isHidden = true
        }
        
        completeButton.do {
            $0.setTitle(StringLiterals.Button.complete, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
        }
    }
    
    func setupHierarchy() {
        addSubviews(linkEmbedTextField, clearButton, completeButton)
    }
    
    func setupLayout() {
        linkEmbedTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        clearButton.snp.makeConstraints {
            $0.top.equalTo(linkEmbedTextField.snp.top).inset(15)
            $0.trailing.equalTo(linkEmbedTextField.snp.trailing).inset(14)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
    }
    
    func setupCell() {
        
    }
    
    func setupAddTarget() {
        
    }
    
    func setupButtonColor() {
        if isButtonClicked {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .toasterPrimary
        } else {
            completeButton.isEnabled = false
            completeButton.backgroundColor = .gray200
        }
    }
}

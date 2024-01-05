//
//  AddClipBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

protocol AddClipBottomSheetDelegate: AnyObject {
    func addClipButtonTapped()
}

final class AddClipBottomSheetView: UIView {
    
    // MARK: - Properties
    
    weak var addClipBottomSheetDelegate: AddClipBottomSheetDelegate?
    
    // MARK: - UI Components
    
    private let addClipTextField = UITextField().then {
        $0.becomeFirstResponder()
        $0.placeholder = StringLiterals.BottomSheet.Placeholder.addClip
        $0.addPadding(left: 14, right: 14)
        $0.backgroundColor = .gray50
        $0.makeRounded(radius: 12)
    }
    
    private let addClipButton = UIButton().then {
        $0.backgroundColor = .toasterPrimary
        $0.setTitle(StringLiterals.BottomSheet.Button.complete, for: .normal)
        $0.setTitleColor(.toasterWhite, for: .normal)
        $0.titleLabel?.font = .suitBold(size: 16)
    }
    
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

private extension AddClipBottomSheetView {
    func setupStyle() {
        backgroundColor = .toasterWhite
    }
    
    func setupHierarchy() {
        addSubviews(addClipTextField, addClipButton)
    }
    
    func setupLayout() {
        addClipTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        addClipButton.snp.makeConstraints {
            // TODO: - 바텀시트 수정후 지정해줘야 하는 부분 (from. 민재)
            // $0.top.equalTo(addClipTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
    }

    func setupAddTarget() {
        addClipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    func buttonTapped() {
        addClipBottomSheetDelegate?.addClipButtonTapped()
    }
}

//
//  AddClipBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

protocol AddClipBottomSheetViewDelegate: AnyObject {
    func dismissButtonTapped()
}

final class AddClipBottomSheetView: UIView {
    
    // MARK: - Properties
    
    weak var addClipBottomSheetViewDelegate: AddClipBottomSheetViewDelegate?
    
    // MARK: - UI Components
    
    private let addClipTextField = UITextField()
    private let addClipButton = UIButton()
    private let errorMessage = UILabel()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupKeyboard()
    }
}

// MARK: - Private Extensions

private extension AddClipBottomSheetView {
    func setupStyle() {
        backgroundColor = .toasterWhite
        
        addClipTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: StringLiterals.BottomSheet.Placeholder.addClip,
                                                          attributes: [.foregroundColor: UIColor.gray400,
                                                                       .font: UIFont.suitRegular(size: 16)])
            $0.addPadding(left: 14, right: 14)
            $0.backgroundColor = .gray50
            $0.textColor = .black900
            $0.makeRounded(radius: 12)
        }
        
        addClipButton.do {
            $0.backgroundColor = .toasterPrimary
            $0.setTitle(StringLiterals.BottomSheet.Button.complete, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        errorMessage.do {
            $0.font = .suitMedium(size: 12)
            $0.textColor = .toasterError
            $0.text = "클립의 이름은 최대 15자까지 입력 가능해요"
        }
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
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
    }
    
    func setupKeyboard() {
        if !addClipTextField.isFirstResponder {
            addClipTextField.becomeFirstResponder()
        }
    }
    
    @objc
    func buttonTapped() {
        addClipBottomSheetViewDelegate?.dismissButtonTapped()
    }
}

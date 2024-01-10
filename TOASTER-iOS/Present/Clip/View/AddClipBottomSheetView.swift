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
    
    private var isButtonClicked: Bool = false {
        didSet {
            setupButtonColor()
        }
    }
    private var isBorderColor: Bool = false {
        didSet {
            setupTextFieldBorder()
        }
    }
    private var isError: Bool = false {
        didSet {
            setupErrorMessage()
        }
    }
    private var isClearButtonShow: Bool = true {
        didSet {
            setupClearButton()
        }
    }
    
    // MARK: - UI Components
    
    private let addClipTextField = UITextField()
    private let addClipButton = UIButton()
    private let errorMessage = UILabel()
    private let clearButton = UIButton()
    
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

extension AddClipBottomSheetView {
    func resetTextField() {
        addClipTextField.text = nil
        addClipTextField.becomeFirstResponder()
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
            $0.addPadding(left: 14, right: 44)
            $0.backgroundColor = .gray50
            $0.textColor = .black900
            $0.makeRounded(radius: 12)
            $0.borderStyle = .none
            $0.isUserInteractionEnabled = true
            $0.delegate = self
        }
        
        addClipButton.do {
            isButtonClicked = false
            $0.setTitle(StringLiterals.BottomSheet.Button.complete, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        errorMessage.do {
            $0.isHidden = true
            $0.font = .suitMedium(size: 12)
            $0.textColor = .toasterError
            $0.text = "클립의 이름은 최대 15자까지 입력 가능해요"
        }
        
        clearButton.do {
            $0.isHidden = true
            $0.setImage(ImageLiterals.Search.searchCancle, for: .normal)
            $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(addClipTextField, addClipButton, errorMessage)
        addClipTextField.addSubview(clearButton)
    }
    
    func setupLayout() {
        addClipTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        errorMessage.snp.makeConstraints {
            $0.top.equalTo(addClipTextField.snp.bottom).offset(6)
            $0.leading.equalTo(addClipTextField)
        }
        
        addClipButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        clearButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    func setupKeyboard() {
        if !addClipTextField.isFirstResponder {
            addClipTextField.becomeFirstResponder()
        }
    }
    
    func setupButtonColor() {
        if isButtonClicked {
            addClipButton.isEnabled = true
            addClipButton.backgroundColor = .toasterPrimary
        } else {
            addClipButton.isEnabled = false
            addClipButton.backgroundColor = .gray200
        }
    }
    
    func setupTextFieldBorder() {
        if isBorderColor {
            addClipTextField.layer.borderColor = UIColor.toasterError.cgColor
            addClipTextField.layer.borderWidth = 1.0
        } else {
            addClipTextField.layer.borderColor = UIColor.clear.cgColor
            addClipTextField.layer.borderWidth = 0.0
        }
    }
    
    func setupErrorMessage() {
        if isError {
            errorMessage.isHidden = false
        } else {
            errorMessage.isHidden = true
        }
    }
    
    func setupClearButton() {
        if isClearButtonShow {
            clearButton.isHidden = false
        } else {
            clearButton.isHidden = true
        }
    }
    
    @objc
    func buttonTapped() {
        addClipBottomSheetViewDelegate?.dismissButtonTapped()
    }
    
    @objc
    func clearButtonTapped() {
        resetTextField()
    }
}

// MARK: - UITextField Delegate

extension AddClipBottomSheetView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let maxLength = 16
        return newText.count <= maxLength
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.isEmpty {
            isButtonClicked = false
            isBorderColor = false
            isError = false
            isClearButtonShow = false
        } else if currentText.count > 15 {
            isButtonClicked = false
            isBorderColor = true
            isError = true
            isClearButtonShow = true
        } else {
            isButtonClicked = true
            isBorderColor = false
            isError = false
            isClearButtonShow = true
        }
    }
}

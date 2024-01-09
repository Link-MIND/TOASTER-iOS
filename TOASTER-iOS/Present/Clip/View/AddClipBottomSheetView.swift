//
//  AddClipBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class AddClipBottomSheetView: UIView {
    
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
        
        addClipTextField.do {
            $0.becomeFirstResponder()
            $0.attributedPlaceholder = NSAttributedString(string: StringLiterals.BottomSheet.Placeholder.addClip,
                                                          attributes: [.foregroundColor: UIColor.gray400,
                                                                       .font: UIFont.suitRegular(size: 16)])
            $0.addPadding(left: 14, right: 14)
            $0.backgroundColor = .gray50
            $0.textColor = .black900
            $0.makeRounded(radius: 12)
            $0.delegate = self
        }
        
        addClipButton.do {
            $0.backgroundColor = .toasterPrimary
            $0.setTitle(StringLiterals.BottomSheet.Button.complete, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
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
            // TODO: - 바텀시트 수정후 지정해줘야 하는 부분 (from. 민재)
            // $0.top.equalTo(addClipTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
//        errorMessage.snp.makeConstraints {
//            $0.top.equalTo(addClipTextField.snp.bottom).offset(6)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
    }
    
    func setupAddTarget() {
        addClipTextField.addTarget(self, action: #selector(addClipTextFieldDidChange), for: .editingChanged)
        addClipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func errorTestField() {
        addClipTextField.layer.borderWidth = 1.0
        addClipTextField.layer.borderColor = UIColor.toasterError.cgColor

    }
    
    @objc
    func addClipTextFieldDidChange() {
        if let textFieldLength: Int = addClipTextField.text?.count {
            if textFieldLength > 15 { errorTestField() }
        }
    }
    
    @objc
    func buttonTapped() {
    }
}

extension AddClipBottomSheetView: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        return newText.count <= 15
//    }
}

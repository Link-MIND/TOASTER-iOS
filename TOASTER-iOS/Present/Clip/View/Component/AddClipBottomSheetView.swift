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
    func addHeightBottom()
    func minusHeightBottom()
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
    
    private(set) var isShareOn: Bool = false {
        didSet {
            shareDescriptionLabel.text = isShareOn
            ? "친구와 함께 저장해요."
            : "나만 볼 수 있어요."
        }
    }
    
    // MARK: - UI Components
    
    private(set) var addClipTextField = UITextField()
    private let addClipButton = UIButton()
    private let errorMessage = UILabel()
    private let clearButton = UIButton()
    
    private let shareTitleLabel = UILabel()
    private let shareDescriptionStack = UIStackView()
    private let shareInfoIcon = UIImageView()
    private let shareDescriptionLabel = UILabel()
    private let shareSwitch = UISwitch()
    
    lazy var textFieldValueChanged = NotificationCenter.default
        .publisher(for: UITextField.textDidChangeNotification, object: self.addClipTextField)
    lazy var addClipButtonTap = addClipButton.publisher(for: .touchUpInside)
    lazy var shareSwitchChanged = shareSwitch.publisher(for: .valueChanged)
    
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
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupKeyboard()
    }
}

// MARK: - Private Extensions

extension AddClipBottomSheetView {
    func resetTextField() {
        addClipTextField.text = nil
    }
    
    func changeTextField(addButton: Bool, border: Bool, error: Bool, clearButton: Bool) {
        isButtonClicked = addButton
        isBorderColor = border
        isError = error
        isClearButtonShow = clearButton
    }
    
    func setupMessage(message: String) {
        errorMessage.text = message
    }
    
    func setupTextField(message: String) {
        addClipTextField.text = message
    }
    
    /// 클립 이름 수정 상황일 경우 사용 - 공유하기 섹션 동작을 모두 숨김
    func setShareSectionHidden() {
        [shareTitleLabel, shareDescriptionStack, shareSwitch].forEach {
            $0.isHidden = true
            $0.isUserInteractionEnabled = false
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - Private Extensions

private extension AddClipBottomSheetView {
    func setupStyle() {
        backgroundColor = .toasterWhite
        
        addClipTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: StringLiterals.Placeholder.addClip,
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
            $0.setTitle(StringLiterals.Button.okay, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
        }
        
        errorMessage.do {
            $0.isHidden = true
            $0.font = .suitMedium(size: 12)
            $0.textColor = .toasterError
        }
        
        clearButton.do {
            $0.isHidden = true
            $0.setImage(.icSearchCancle, for: .normal)
            $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        }
        
        shareTitleLabel.do {
            $0.text = "공유하기"
            $0.font = .suitMedium(size: 16)
            $0.textColor = .black900
        }
        
        shareDescriptionStack.do {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .leading
            $0.isLayoutMarginsRelativeArrangement = false
        }
        
        shareInfoIcon.do {
            $0.image = .icAlert18Dark
            $0.contentMode = .scaleAspectFit
        }
        
        shareDescriptionLabel.do {
            $0.font = .suitMedium(size: 13)
            $0.textColor = .gray400
            $0.text = "나만 볼 수 있어요."
        }
        
        shareSwitch.do {
            $0.onTintColor = .toasterPrimary
            $0.isOn = isShareOn
            $0.isUserInteractionEnabled = true
            $0.addTarget(self, action: #selector(shareSwitchValueChanged), for: .valueChanged)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            addClipTextField,
            errorMessage,
            shareTitleLabel,
            shareDescriptionStack,
            shareSwitch,
            addClipButton
        )
        addClipTextField.addSubview(clearButton)
        shareDescriptionStack.addArrangedSubviews(shareInfoIcon, shareDescriptionLabel)
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
        
        shareTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(addClipButton.snp.top).offset(-26)
            $0.leading.equalToSuperview().inset(20)
        }
        
        shareDescriptionStack.snp.makeConstraints {
            $0.centerY.equalTo(shareTitleLabel)
            $0.leading.equalTo(shareTitleLabel.snp.trailing).offset(12)
        }
        
        shareInfoIcon.snp.makeConstraints {
            $0.size.equalTo(14)
        }
        
        shareSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalTo(shareTitleLabel)
            $0.width.equalTo(40)
            $0.height.equalTo(24)
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
            addClipBottomSheetViewDelegate?.addHeightBottom()
            errorMessage.isHidden = false
        } else {
            addClipBottomSheetViewDelegate?.minusHeightBottom()
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
    func clearButtonTapped() {
        resetTextField()
    }
    
    @objc
    func shareSwitchValueChanged(_ sender: UISwitch) {
        isShareOn = sender.isOn
    }
}

// MARK: - UITextField Delegate

extension AddClipBottomSheetView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let currentText = textField.text ?? ""
        let maxLength = 16
        
        // 길이가 16에서 15로 돌아갈 때
        if currentText.count == maxLength && newText.count == 15 {
            addClipBottomSheetViewDelegate?.minusHeightBottom()
        }
        return newText.count <= maxLength
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let currentText = textField.text ?? ""
        if currentText.isEmpty {
            changeTextField(addButton: false, border: false, error: false, clearButton: false)
        } else if currentText.count > 15 {
            changeTextField(addButton: false, border: true, error: true, clearButton: true)
            setupMessage(message: "클립의 이름은 최대 15자까지 입력 가능해요")
        } else {
            changeTextField(addButton: true, border: false, error: false, clearButton: true)
        }
    }
}

//
//  AddLinkView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/12.
//

import UIKit

import SnapKit
import Then

final class AddLinkView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private var timer: Timer?
    private var keyboardHeight: CGFloat = 100
    
    // MARK: - UI Components
    
    private let descriptLabel = UILabel()
    private let linkEmbedTextField = UITextField()
    
    private let nextBottomButton = UIButton()
    private let nextTopButton = UIButton()
    
    lazy var accessoryView: UIView = { return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 56.0)) }()
    
    private let errorLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        linkEmbedTextField.delegate = self
        linkEmbedTextField.resignFirstResponder()
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Make View
    
    func setView() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @objc func tappedNextBottomButton() {
        if (linkEmbedTextField.text?.count ?? 0) < 1 {
            emptyError()
        } else {
            // 클립 저장으로 이동
        }
        
    }
    
    @objc func tappedNextTopButton() {
        if (linkEmbedTextField.text?.count ?? 0) < 1 {
            emptyError()
        } else {
            // 클립 저장으로 이동
        }
    }
    
    @objc func textFieldDidChange() {
        nextBottomButton.backgroundColor = .black850
        nextBottomButton.isEnabled = true
    }
}

// MARK: - Private extension

private extension AddLinkView {
    
    func setupStyle() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.backgroundColor = .toasterBackground
        
        descriptLabel.do {
            $0.text = "링크를 입력해주세요"
            $0.font = .suitMedium(size: 18)
        }
        
        linkEmbedTextField.do {
            $0.placeholder = "복사한 링크를 붙여 넣어 주세요"
            $0.tintColor = .toasterPrimary
            $0.backgroundColor = .gray50
            $0.makeRounded(radius: 12)
            $0.inputAccessoryView = accessoryView
            $0.clearButtonMode = .always
            $0.addPadding(left: 15.0)
            $0.addTarget(self, action: #selector(self.textFieldDidChange), for: .touchUpInside)
        }
        
        nextBottomButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.backgroundColor = .gray200
            $0.makeRounded(radius: 12)
            $0.addTarget(self, action: #selector(tappedNextBottomButton), for: .touchUpInside)
        }
        
        nextTopButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.backgroundColor = .black850
            $0.addTarget(self, action: #selector(tappedNextTopButton), for: .touchUpInside)
        }
        
        errorLabel.do {
            $0.textColor = .toasterError
            $0.font = .suitMedium(size: 12)
        }
    }
    
    func setupHierarchy() {
        addSubviews(descriptLabel, linkEmbedTextField, nextBottomButton)
        accessoryView.addSubview(nextTopButton)
    }
    
    func setupLayout() {
        descriptLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        linkEmbedTextField.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(54)
        }
        
        nextBottomButton.snp.makeConstraints {
            $0.top.equalTo(super.snp.bottom).inset(96)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(62)
        }
        
        // 키보드 위의 버튼
        nextTopButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(56)
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
           // updateBottomSheetLayout()
        }
    }
}

// MARK: - Extension

extension AddLinkView {
    
    // MARK: - Timer Check
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트 필드에 입력이 시작될 때 호출되는 메서드
        nextTopButton.backgroundColor = .black850
        linkEmbedTextField.placeholder = nil
        // 여기서 타이머를 시작하고, 1.5초 후에 텍스트를 확인하고 테두리 색상을 변경합니다.
        if textField.text?.count ?? 0 > 1 {
            startTimer()
        } else {
            // 버튼 클릭시 링크를 입력해주세요 에러
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 입력이 발생할 때마다 호출되는 메서드
        // 여기서 타이머를 재시작
        restartTimer()
        return true
    }
    
    func startTimer() {
        // 1.5초 후에 checkTextField 메서드 호출
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            // URL 유효 여부 판단 후 처리
            if let urlText = self?.linkEmbedTextField.text {
                if urlText.contains("http") {
                    print("유효한 링크입니다. :", urlText)
                    self?.resetError()
                } else {
                    print("유효하지 않은 링크입니다. :", urlText)
                    self?.isValidLinkError()
                }
            }
        }
    }
    
    func restartTimer() {
        // 타이머 재시작
        stopTimer()
        startTimer()
    }
    
    func stopTimer() {
        // 타이머를 정지, 테두리 초기화
        timer?.invalidate()
        linkEmbedTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    // MARK: - URL 유효성 검사
    
    // 화면 구현 완성하고 검사할게요
    func isValidURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString else {
            return false
        }
        // 정규표현식을 사용하여 URL 패턴 확인
        let urlPattern = #"^(https?|ftp):\/\/[^\s\/$.?#].[^\s]*$"# // 간단한 URL 패턴
        let regex = try? NSRegularExpression(pattern: urlPattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: urlString.utf16.count)
        
        return regex?.firstMatch(in: urlString, options: [], range: range) != nil
    }
    
    // MARK: - Text Field Error
    
    // 링크를 입력하는 텍스트필드가 비어 있을 경우 error 처리
    func emptyError() {
        linkEmbedTextField.layer.borderColor = UIColor.toasterError.cgColor
        linkEmbedTextField.layer.borderWidth = 1
        
        // Button 비활성화
        nextTopButton.backgroundColor = .gray200
        nextBottomButton.backgroundColor = .gray200
        nextTopButton.isEnabled = false
        nextBottomButton.isEnabled = false
        
        errorLabel.text = "링크를 입력해주세요"
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(linkEmbedTextField.snp.bottom).offset(6)
            $0.leading.equalTo(linkEmbedTextField.snp.leading)
        }
        
        errorLabel.isHidden = false
    }
    
    // 링크가 유효하지 않을 경우 error 처리
    func isValidLinkError() {
        linkEmbedTextField.layer.borderColor = UIColor.toasterError.cgColor
        linkEmbedTextField.layer.borderWidth = 1
        
        // Button 비활성화
        nextTopButton.backgroundColor = .gray200
        nextBottomButton.backgroundColor = .gray200
        nextTopButton.isEnabled = false
        nextBottomButton.isEnabled = false
        
        errorLabel.text = "유효하지 않은 형식의 링크입니다"
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(linkEmbedTextField.snp.bottom).offset(6)
            $0.leading.equalTo(linkEmbedTextField.snp.leading)
        }
        errorLabel.isHidden = false
    }
    
    // 링크가 유효할 경우, error reset
    func resetError() {
        linkEmbedTextField.layer.borderColor = UIColor.clear.cgColor
        
        // Button 활성화
        nextTopButton.backgroundColor = .black850
        nextBottomButton.backgroundColor = .black850
        nextTopButton.isEnabled = true
        nextBottomButton.isEnabled = true
        
        errorLabel.isHidden = true
    }
}

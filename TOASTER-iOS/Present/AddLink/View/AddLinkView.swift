//
//  AddLinkView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/04.
//

import UIKit

import SnapKit
import Then

final class AddLinkView: UIView {
    
    // MARK: - Properties
    
    private let descriptLabel = UILabel()
    private let linkEmbedTextField = UITextField()
    private let titleDescriptLabel = UILabel()
    private let titleTextField = UITextField()
    private let nextButton = UIButton()
    private let checkButton = UIButton()
    
    // keyboard 위에 올라갈 checkButton을 위한 View
    lazy var accessoryView: UIView = { return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 56.0)) }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        linkEmbedTextField.delegate = self
        titleTextField.delegate = self
        linkEmbedTextField.resignFirstResponder()
        setView()
        setupAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set up View
    
    func setView() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - @objc
    
    @objc func tappedBottomNextButton() {
        _ = linkEmbedTextField.text! //링크 -> 서버에 넘겨주기
        // metaData() network
        setupTitleTextFieldLayout()
        
        // TODO 서버 통신 이후 title로 가져올 것
        // 분기처리 : title 15자 자르기
        titleTextField.text = linkEmbedTextField.text
        titleTextField.becomeFirstResponder()
    }
    
    @objc func tappedTopNextButton() {
        linkEmbedTextField.resignFirstResponder()
        nextButton.backgroundColor = .black850
        nextButton.isEnabled = true
    }
    
    @objc func linkEmbedtextFieldDidChange(_ sender: Any?) {
        let textCount = linkEmbedTextField.text!.count
        if textCount > 0 {
            checkButton.backgroundColor = .black850
            checkButton.isEnabled = true
        } else {
            checkButton.backgroundColor = .gray100
            checkButton.isEnabled = false
        }
    }
    
    @objc func titletextFieldDidChange(_ sender: Any?) {
        let textCount = titleTextField.text!.count
        print("🩷🩷🩷", titleTextField.text)
        // text가 15자 초과 시 Text Field Error
        if textCount > 15 {
            titleTextField.layer.borderColor = UIColor.toasterError.cgColor
            titleTextField.layer.borderWidth = 1
        } else {
            titleTextField.tintColor = .toasterPrimary
            titleTextField.layer.borderWidth = 0
        }
    }
}

private extension AddLinkView {
    func setupAddTarget() {
        linkEmbedTextField.addTarget(self, action: #selector(linkEmbedtextFieldDidChange(_:)), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(titletextFieldDidChange(_:)), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(tappedBottomNextButton), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(tappedTopNextButton), for: .touchUpInside)
    }
    
    func setupStyle() {
        self.backgroundColor = .toasterBackground
        
        descriptLabel.do {
            $0.text = "링크를 입력하세요" // 나중에 StringLiterals로 빼쟈
            $0.font = .suitMedium(size: 18)
        }
        
        linkEmbedTextField.do {
            $0.placeholder = "복사한 링크를 붙여 넣어 주세요"
            $0.tintColor = .toasterPrimary
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 12
            $0.inputAccessoryView = accessoryView
            $0.clearButtonMode = .always
            $0.addPadding(left: 15.0)
        }
        
        titleDescriptLabel.do {
            $0.text = "제목을 입력해주세요"
            $0.font = .suitMedium(size: 18)
        }
        
        titleTextField.do {
            $0.tintColor = .toasterPrimary
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 12
            $0.inputAccessoryView = accessoryView
            $0.clearButtonMode = .always
            $0.addPadding(left: 15.0)
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 12
        }
        
        checkButton.do {
            $0.setTitle("확인", for: .normal)
            $0.backgroundColor = .gray100
        }
        
        [nextButton, checkButton].forEach {
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.isEnabled = false
        }
    }
    
    func setupHierarchy() {
        addSubviews(descriptLabel, linkEmbedTextField, nextButton)
        accessoryView.addSubview(checkButton)
    }
    
    func setupLayout() {
        descriptLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(75)
            $0.leading.equalToSuperview().inset(35)
            $0.height.equalTo(22)
            $0.width.equalTo(146)
        }
        
        linkEmbedTextField.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(54)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(super.snp.bottom).inset(96)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(62)
        }
        
        // 키보드 위에 버튼 올리기 위한 Layout
        guard let checkButtonSuperView = checkButton.superview else { return }
        checkButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(checkButtonSuperView)
            $0.height.equalTo(56)
        }
        
    }
    
    func setupTitleTextFieldLayout() {
        addSubviews(titleDescriptLabel, titleTextField)
        titleDescriptLabel.snp.makeConstraints {
            $0.top.equalTo(linkEmbedTextField.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(35)
            $0.height.equalTo(22)
            $0.width.equalTo(146)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleDescriptLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(54)
        }
    }
}

extension AddLinkView: UITextFieldDelegate {

    // UITextFieldDelegate 메서드 - 텍스트가 변경될 때 호출됩니다.
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            // bbbTextField에 대해서만 길이 제한을 두기 위해 조건을 추가합니다.
//            if textField == titleTextField {
//                // 새로 입력된 문자열을 포함한 총 텍스트 길이를 계산합니다.
//                let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//                
//                // 최대 길이를 15로 제한합니다.
//                let maxLength = 15
//                return newText.count <= maxLength
//            }
//
//            // aaaTextField나 다른 텍스트 필드는 별도의 제한을 두지 않습니다.
//            return true
//        }
}

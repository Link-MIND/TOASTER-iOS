//
//  AddLinkView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/04.
//

import UIKit

import SnapKit
import Then

final class AddLinkView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let descriptLabel = UILabel()
    private let urlTextField = UITextField()
    private let titleDescriptLabel = UILabel()
    private let titleTextField = UITextField()
    private let nextButton = UIButton()
    private let checkButton = UIButton()
    
    // keyboard 위에 올라갈 checkButton을 위한 View
    lazy var accessoryView: UIView = { return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 56.0)) }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        urlTextField.delegate = self
        urlTextField.resignFirstResponder()
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
    
    @objc func tappedNextButton() {
        _ = urlTextField.text! //링크 -> 서버에 넘겨주기
        // metaData() network
        setupTitleTextFieldLayout()
        titleTextField.text = urlTextField.text
        // 키보드 올리기 :  titleTextfield.becomeFirstResponder()
    }
    
    @objc func tappedCheckButton() {
        urlTextField.resignFirstResponder() // 키보드 내려가고
        nextButton.backgroundColor = .black850 // 다음 버튼 검정색으로 바뀌고
        nextButton.isEnabled = true //활성화
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        let textCount = urlTextField.text!.count
        if textCount > 0 {
            checkButton.backgroundColor = .black850
            checkButton.isEnabled = true
        } else {
            checkButton.backgroundColor = .gray100
            checkButton.isEnabled = false
        }
    }
}

private extension AddLinkView {
    func setupAddTarget() {
        urlTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
        checkButton.addTarget(self, action: #selector(tappedCheckButton), for: .touchUpInside)
    }
    
    func setupStyle() {
        self.backgroundColor = .toasterBackground
        
        descriptLabel.do {
            $0.text = "링크를 입력하세요" // 나중에 StringLiterals로 빼쟈
            $0.font = .suitMedium(size: 18)
        }
        
        urlTextField.do {
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
        addSubviews(descriptLabel, urlTextField, nextButton)
        // self.addSubview(titleTextField)
        accessoryView.addSubview(checkButton)
    }
    
    func setupLayout() {
        descriptLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(75)
            $0.leading.equalToSuperview().inset(35) //20으로 해보기
            $0.height.equalTo(22)
            $0.width.equalTo(146)
        }
        
        urlTextField.snp.makeConstraints {
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
            $0.top.equalTo(urlTextField.snp.bottom).offset(18)
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

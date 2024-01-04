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
    let urlTextField = UITextField()
    // private let titleTextField = UITextField()
    private let nextButton = UIButton()
    private let checkButton = UIButton()
    
    lazy var accessoryView: UIView = { return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 56.0)) }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        urlTextField.delegate = self
        urlTextField.resignFirstResponder()
        setView()
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
    
    @objc func tappedNextButton() {
        nextButton.backgroundColor = .black850
        let urlLink = urlTextField.text!
        // metaData()
    }
    
    @objc func tappedCheckButton() {
        print("확인 버튼이 눌렸다용")
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        let textCount = urlTextField.text!.count
        if textCount > 0 {
            checkButton.backgroundColor = .black850
        }
        else {
            checkButton.backgroundColor = .gray100
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
}

private extension AddLinkView {
    
    func setupStyle() {
        self.backgroundColor = .toasterBackground
        
        descriptLabel.do {
            $0.text = "링크를 입력하세요"
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
            $0.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        //        titleTextField.do {
        //            $0.backgroundColor = .white
        //            $0.layer.borderColor = UIColor.black.cgColor
        //            $0.layer.borderWidth = 1
        //        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
        }
        
        checkButton.do {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.backgroundColor = .gray100
            $0.addTarget(self, action: #selector(tappedCheckButton), for: .touchUpInside)
        }
        
    }
    
    func setupHierarchy() {
        self.addSubview(descriptLabel)
        self.addSubview(urlTextField)
        self.addSubview(nextButton)
        // self.addSubview(titleTextField)
        accessoryView.addSubview(checkButton)
    }
    
    func setupLayout() {
        descriptLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(75)
            $0.leading.equalToSuperview().inset(35)
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
        
        //        titleTextField.snp.makeConstraints {
        //            $0.top.equalTo(urlTextField.snp.bottom).offset(50)
        //            $0.leading.equalToSuperview().inset(30)
        //            $0.width.equalTo(300)
        //            $0.height.equalTo(45)
        //        }
        
        // 키보드 위에 버튼 올리기 위한 Layout
        guard let checkButtonSuperView = checkButton.superview else { return }
        checkButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(checkButtonSuperView)
            $0.height.equalTo(56)
        }
        
    }
}

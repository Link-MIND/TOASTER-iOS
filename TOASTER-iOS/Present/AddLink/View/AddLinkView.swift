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
    
    var timer : Timer?
    
    // MARK: - UI Components
    
    private let descriptLabel = UILabel()
    private let urlTextField = UITextField()
    
    private let nextButton = UIButton()
    private let checkButton = UIButton()
    
    lazy var accessoryView: UIView = { return UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 72.0)) }()
    
    private let errorLabel = UILabel()
    
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
    
    // MARK: - Make View
    
    func setView() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    // 다음 버튼
    @objc func tappedNextButton() {
        nextButton.backgroundColor = .black
        let urlLink = urlTextField.text!
        //metaData()
    }
    
    // 확인 버튼
    // textField is Empty -> ERROR
    // else -> timer check 후 링크텍스트 가져오기
    @objc func tappedCheckButton() {
        if (urlTextField.text?.count ?? 0) < 1 {
            checkButton.backgroundColor = .lightGray
            urlTextField.layer.borderColor = UIColor.red.cgColor
            print("링크를 입력해주세요 ")
            // acButton 비활성화
            // 텍스트 필드 테두리 빨간색
            // 에러 메세지 - 링크를 입력해주세요
        } else {
            // URL 유효한지 판단
            // 클립 저장으로 이동
        }
    }
    
    // 확인 버튼 색상 변경
    @objc func textFieldDidChange(_ sender: Any?) {
    }
    
//    private func metaData() {
//        
//        // url Text Field에 입력한 URL 링크 Title 가져오기
//        let metadataProvider = LPMetadataProvider()
//        let url = URL(string: urlTextField.text ?? "ERROR")!
//        //        metadataProvider.startFetchingMetadata(for: url)
//        //        { (returnedMetadata, error) in
//        //            if let metadata = returnedMetadata, error == nil {
//        //                print("💙Title💙 : " + (metadata.title ?? "No Title"))
//        //                ss = metadata.title ?? "No Title"
//        //                //self.titleTextField.text = metadata.title
//        //            }
//        //            print(ss)
//        //            //titleTextField.text = ss
//        //        }
//        metadataProvider.startFetchingMetadata(for: url) { returnedMetaData, error in
//            let metadata = returnedMetaData
//            print("💙" + (metadata?.title ?? "No Title"))
//        }
//    }
}

private extension AddLinkView {
    
    func setupStyle() {
        self.backgroundColor = .white
        
        descriptLabel.do {
            $0.text = "링크를 입력하세요"
            $0.font = .systemFont(ofSize: 22)
        }
        
        urlTextField.do {
            $0.placeholder = "url"
            $0.backgroundColor = .clear
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 0.3
            $0.inputAccessoryView = accessoryView
            $0.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .lightGray
            $0.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
            $0.layer.cornerRadius = 9
        }
        
        checkButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black
            $0.addTarget(self, action: #selector(tappedCheckButton), for: .touchUpInside)
        }
        
        errorLabel.do {
            $0.text = "error"
            $0.textColor = .red
        }
    }
    
    
    func setupHierarchy() {
        self.addSubview(descriptLabel)
        self.addSubview(urlTextField)
        self.addSubview(nextButton)
        accessoryView.addSubview(checkButton)
    }
    
    func setupLayout() {
        descriptLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(75)
            $0.leading.equalToSuperview().inset(35)
        }
        
        urlTextField.snp.makeConstraints {
            $0.top.equalTo(descriptLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(300)
            $0.height.equalTo(45)
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
            $0.leading.trailing.equalTo(checkButtonSuperView).inset(15)
            $0.height.equalTo(56)
        }
        
    }
}


extension AddLinkView {
    
    // MARK: - Timer Check
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 텍스트 필드에 입력이 시작될 때 호출되는 메서드
        checkButton.backgroundColor = .black
        // 여기서 타이머를 시작하고, 1.5초 후에 텍스트를 확인하고 테두리 색상을 변경합니다.
        if textField.text?.count ?? 0 > 1 {
            startTimer()
        } else {
            // 버튼 클릭시 링크를 입력해주세요 에러
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 입력이 발생할 때마다 호출되는 메서드
        // 여기서 타이머를 재시작합니다.
        restartTimer()
        return true
    }
    
    //private var timer: Timer?
    
    func startTimer() {
        // 1.5초 후에 checkTextField 메서드 호출
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
            
            if let urlText = self?.urlTextField.text {
                if urlText.contains("http") {
                    print("유효한 링크입니다. :", urlText)
                    self?.urlTextField.layer.borderColor = UIColor.black.cgColor
                    self?.checkButton.backgroundColor = .black
                } else {
                    print("유효하지 않은 링크입니다. :", urlText)
                    self?.urlTextField.layer.borderColor = UIColor.red.cgColor
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
        // 타이머를 정지하고 테두리를 초기화
        timer?.invalidate()
        urlTextField.layer.borderColor = UIColor.black.cgColor
        urlTextField.layer.borderWidth = 1.0
    }

    // MARK: - URL 유효성 검사
    
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
}

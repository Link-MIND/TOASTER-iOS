//
//  ToasterPopupViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/2/24.
//

import UIKit

import SnapKit
import Then

final class ToasterPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias buttonAction = () -> Void
    
    private var mainText: String?
    private var subText: String?
    private var leftButtonTitle: String = ""
    private var rightButtonTitle: String = ""
    private var leftButtonHandler: buttonAction?
    private var rightButtonHandler: buttonAction?
    
    // MARK: - UI Properties
    
    private let popupStackView: UIStackView = UIStackView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let mainLabel: UILabel = UILabel()
    private let subLabel: UILabel = UILabel()
    
    private let buttonStackView: UIStackView = UIStackView()
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(mainText: String?,
         subText: String?,
         leftButtonTitle: String,
         rightButtonTitle: String,
         leftButtonHandler: buttonAction?,
         rightButtonHandler: buttonAction?) {
        
        self.mainText = mainText
        self.subText = subText
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonAction()
    }
}

// MARK: - Private Extensions

private extension ToasterPopupViewController {
    
    func cancleAction() {
        dismiss(animated: false)
    }
    
    func setupStyle() {
        view.backgroundColor = .black900.withAlphaComponent(0.5)
        
        popupStackView.do {
            $0.spacing = 18
            $0.axis = .vertical
            $0.alignment = .fill
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .toasterWhite
            $0.layoutMargins = UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 24)
            $0.isLayoutMarginsRelativeArrangement = true
        }
        
        labelStackView.do {
            $0.spacing = 12
            $0.axis = .vertical
            $0.alignment = .fill
        }
        
        mainLabel.do {
            $0.text = mainText
            $0.numberOfLines = 0
            $0.textColor = .gray800
            $0.font = subText == nil ? .suitBold(size: 16) : .suitBold(size: 20)
        }
        
        subLabel.do {
            $0.text = subText
            $0.numberOfLines = 0
            $0.textColor = .gray800
            $0.font = .suitRegular(size: 16)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
        }
        
        leftButton.do {
            $0.makeRounded(radius: 8)
            $0.backgroundColor = .gray50
            $0.setTitle(leftButtonTitle, for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.font = .suitSemiBold(size: 16)
        }
        
        rightButton.do {
            $0.makeRounded(radius: 8)
            $0.backgroundColor = .toasterPrimary
            $0.setTitle(rightButtonTitle, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitSemiBold(size: 16)
        }
    }
    
    func setupHierarchy() {
        view.addSubview(popupStackView)
        popupStackView.addArrangedSubviews(labelStackView,
                                           buttonStackView)
        if let _ = mainText {
            labelStackView.addArrangedSubview(mainLabel)
        }
        if let _ = subText {
            labelStackView.addArrangedSubview(subLabel)
        }
        buttonStackView.addArrangedSubviews(leftButton,
                                            rightButton)
    }
    
    func setupLayout() {
        popupStackView.snp.makeConstraints {
            $0.width.equalTo(view.convertByWidthRatio(300))
            $0.center.equalToSuperview()
        }
        
        [leftButton, rightButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(121)
                $0.height.equalTo(48)
            }
        }
    }
    
    func setupButtonAction() {
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    @objc func leftButtonTapped() {
        if let action = leftButtonHandler {
            action()
        } else {
            cancleAction()
        }
    }
    
    @objc func rightButtonTapped() {
        if let action = rightButtonHandler {
            action()
        } else {
            cancleAction()
        }
    }
}

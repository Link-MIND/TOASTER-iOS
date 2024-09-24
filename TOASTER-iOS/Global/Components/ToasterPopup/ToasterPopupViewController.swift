//
//  ToasterPopupViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/2/24.
//

import UIKit

import SnapKit
import Then

enum ToasterPopupType {
    case Confirmation // 가운테 버튼 존재
    case Cancelable // 좌,우 버튼 존재
    case Limitation // 가운데 버튼 아래 기간 설정 버튼 존재
}

final class ToasterPopupViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias ButtonAction = () -> Void
    
    private var popupType: ToasterPopupType
    private var mainText: String?
    private var subText: String?
    private var imageURL: String?
    private var leftButtonTitle: String = ""
    private var rightButtonTitle: String = ""
    private var centerButtonTitle: String = ""
    private var bottomButtonTitle: String = ""
    private var leftButtonHandler: ButtonAction?
    private var rightButtonHandler: ButtonAction?
    private var centerButtonHandler: ButtonAction?
    private var bottomButtonHandler: ButtonAction?
    private var closeButtonHandler: ButtonAction?
    
    // MARK: - UI Properties
    
    private let popupStackView: UIStackView = UIStackView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let mainLabel: UILabel = UILabel()
    private let subLabel: UILabel = UILabel()
    private let popupImage: UIImageView = UIImageView()
    
    private let buttonStackView: UIStackView = UIStackView()
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    private let centerButton: UIButton = UIButton()
    private let bottomButton: UIButton = UIButton()
    private let closeButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(mainText: String?,
         subText: String?,
         leftButtonTitle: String,
         rightButtonTitle: String,
         leftButtonHandler: ButtonAction?,
         rightButtonHandler: ButtonAction?) {
        
        self.mainText = mainText
        self.subText = subText
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        
        if centerButtonTitle.isEmpty {
            self.popupType = .Cancelable
        } else {
            self.popupType = .Confirmation
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 확인 ( 에러 ) 을 위한 Popup init
    init(mainText: String?,
         subText: String?,
         centerButtonTitle: String,
         centerButtonHandler: ButtonAction?) {
        
        self.mainText = mainText
        self.subText = subText
        self.leftButtonTitle = ""
        self.rightButtonTitle = ""
        self.centerButtonTitle = centerButtonTitle
        self.leftButtonHandler = nil
        self.rightButtonHandler = nil
        self.centerButtonHandler = centerButtonHandler
        
        if centerButtonTitle.isEmpty {
            self.popupType = .Cancelable
        } else {
            self.popupType = .Confirmation
        }
    
        super.init(nibName: nil, bundle: nil)
    }
    
    init(mainText: String?,
         subText: String?,
         imageURL: String?,
         centerButtonTitle: String,
         bottomButtonTitle: String,
         centerButtonHandler: ButtonAction?,
         bottomButtonHandler: ButtonAction?,
         closeButtonHandler: ButtonAction?) {
        
        self.mainText = mainText
        self.subText = subText
        self.imageURL = imageURL
        self.centerButtonTitle = centerButtonTitle
        self.bottomButtonTitle = bottomButtonTitle
        self.centerButtonHandler = nil
        self.bottomButtonHandler = nil
        self.closeButtonHandler = nil

        if bottomButtonTitle.isEmpty {
            self.popupType = .Confirmation
        } else {
            self.popupType = .Limitation
        }
        
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
        
        popupImage.do {
            $0.kf.setImage(with: URL(string: imageURL ?? ""))
        }
        
        buttonStackView.do {
            $0.axis = popupType == .Limitation ? .vertical : .horizontal
            $0.spacing = popupType == .Confirmation ? 0 : 10
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
        
        centerButton.do {
            $0.makeRounded(radius: 8)
            $0.backgroundColor = .toasterPrimary
            $0.setTitle(centerButtonTitle, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
        }
        
        bottomButton.do {
            let attributedString = NSAttributedString(
                string: bottomButtonTitle,
                attributes: [
                    .foregroundColor: UIColor.gray800,
                    .font: UIFont.suitRegular(size: 14),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
            )
            $0.setAttributedTitle(attributedString, for: .normal)
        }
        
        closeButton.do {
            $0.setImage(.icClose24, for: .normal)
            $0.tintColor = .black850
            $0.isHidden = popupType == .Limitation ? false : true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(popupStackView)
        
        if mainText != nil { labelStackView.addArrangedSubview(mainLabel) }
        if subText != nil { labelStackView.addArrangedSubview(subLabel) }
        if imageURL != nil { labelStackView.addArrangedSubviews(popupImage) }
                
        switch popupType {
        case .Cancelable:
            buttonStackView.addArrangedSubviews(leftButton, rightButton)
        case .Confirmation:
            buttonStackView.addArrangedSubviews(centerButton)
        case .Limitation:
            buttonStackView.addArrangedSubviews(centerButton, bottomButton)
        }
        popupStackView.addArrangedSubviews(labelStackView, buttonStackView)
        popupStackView.addSubview(closeButton)
    }
    
    func setupLayout() {
        popupStackView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(20)
        }
        
        if popupType == .Cancelable {
            [leftButton, rightButton].forEach {
                $0.snp.makeConstraints {
                    $0.width.equalTo(121)
                    $0.height.equalTo(48)
                }
            }
        } else {
            centerButton.snp.makeConstraints {
                $0.width.equalTo(252)
                $0.height.equalTo(48)
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    func setupButtonAction() {
        leftButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        switch sender {
        case leftButton: leftButtonHandler?() ?? cancelAction()
        case rightButton: rightButtonHandler?() ?? cancelAction()
        case centerButton: centerButtonHandler?() ?? cancelAction()
        case bottomButton: bottomButtonHandler?() ?? cancelAction()
        case closeButton: closeButtonHandler?() ?? cancelAction()
        default: break
        }
    }
    
    func cancelAction() {
        dismiss(animated: false)
    }
}

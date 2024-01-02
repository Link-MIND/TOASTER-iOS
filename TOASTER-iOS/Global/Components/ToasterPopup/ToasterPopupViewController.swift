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
    
    // MARK: - UI Properties
    
    private let popupStackView: UIStackView = UIStackView()
    
    private let labelStackView: UIStackView = UIStackView()
    private let mainLabel: UILabel = UILabel()
    private let subLabel: UILabel = UILabel()
    
    private let buttonStackView: UIStackView = UIStackView()
    private let leftButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
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
            $0.textColor = .gray800
            $0.font = .suitBold(size: 20)
        }
        
        subLabel.do {
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
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.font = .suitSemiBold(size: 16)
        }
        
        rightButton.do {
            $0.makeRounded(radius: 8)
            $0.backgroundColor = .toasterPrimary
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitSemiBold(size: 16)
        }
    }
    
    func setupHierarchy() {
        view.addSubview(popupStackView)
        popupStackView.addArrangedSubviews(labelStackView,
                                           buttonStackView)
        labelStackView.addArrangedSubviews(mainLabel,
                                           subLabel)
        buttonStackView.addArrangedSubviews(leftButton,
                                            rightButton)
    }
    
    func setupLayout() {
        popupStackView.snp.makeConstraints {
            $0.width.equalTo(view.convertByWidthRatio(300))
            $0.center.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        [leftButton, rightButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(121)
                $0.height.equalTo(48)
            }
        }
    }
}

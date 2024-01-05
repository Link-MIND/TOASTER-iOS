//
//  ToasterNavigationController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/4/24.
//

import UIKit

final class ToasterNavigationController: UINavigationController {

    // MARK: - Properties

    private let navigationHeight: CGFloat = 64
    
    // MARK: - UI Properties

    private let safeAreaView: UIView = UIView()
    private let customNavigationBar: UIView = UINavigationBar()
    
    private let leftStackView: UIStackView = UIStackView()
    private let mainImageView: UIImageView = UIImageView()
    private let mainTitleLabel: UILabel = UILabel()
    private let backButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupHierarchy()
        setupLayout()
        hideDefaultNavigationBar()
        setupSafeArea(navigationBarHidden: isNavigationBarHidden)
    }
    
    override var isNavigationBarHidden: Bool {
        didSet {
            hideDefaultNavigationBar()
            safeAreaView.isHidden = isNavigationBarHidden
            customNavigationBar.isHidden = isNavigationBarHidden
            setupSafeArea(navigationBarHidden: isNavigationBarHidden)
        }
    }
}

extension ToasterNavigationController {
    func setupNavigationBar(forType: ToasterNavigationType) {
        backButton.isHidden = !forType.hasBackButton
        rightButton.isHidden = !forType.hasRightButton
        
        if forType.hasMainImage {
            mainTitleLabel.isHidden = true
            mainImageView.image = forType.mainImage
        } else {
            mainImageView.isHidden = true
            mainTitleLabel.text = forType.mainTitle
        }
        
        if forType.hasRightButtonImage {
            rightButton.setImage(forType.rightButtonImage, for: .normal)
        } else {
            rightButton.setTitle(forType.rightButtonTitle, for: .normal)
        }
        
    }
}

// MARK: - Private Extensions

private extension ToasterNavigationController {
    
    func setupStyle() {
        customNavigationBar.do {
            $0.backgroundColor = .toasterWhite
        }
        
        safeAreaView.do {
            $0.backgroundColor = customNavigationBar.backgroundColor
        }
        
        leftStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
        }
        
        mainTitleLabel.do {
            $0.font = .suitBold(size: 18)
            $0.textColor = .black900
        }
        
        backButton.do {
            $0.setImage(ImageLiterals.Common.arrowLeft, for: .normal)
        }
        
        rightButton.do {
            $0.titleLabel?.font = .suitBold(size: 14)
            $0.setTitleColor(.gray600, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(safeAreaView, customNavigationBar)
        customNavigationBar.addSubviews(leftStackView, rightButton)
        leftStackView.addArrangedSubviews(backButton, mainTitleLabel, mainImageView)
    }
    
    func setupLayout() {
        customNavigationBar.snp.makeConstraints {
            $0.height.equalTo(navigationHeight)
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
        
        safeAreaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
        
        leftStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    /// navigationBar가 hidden 상태인지 아닌지에 따라 view의 safeArea를 정해주는 함수
    func setupSafeArea(navigationBarHidden: Bool) {
        if navigationBarHidden {
            additionalSafeAreaInsets = UIEdgeInsets(top:0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        } else {
            additionalSafeAreaInsets = UIEdgeInsets(top: navigationHeight,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        }
    }
    
    /// DetaultNavigationBar를 hidden 시켜주는 함수
    func hideDefaultNavigationBar() {
        navigationBar.isHidden = true
    }
}

//
//  OnboardingViewController.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 2/21/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private(set) var onboardType: OnboardingType
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let onboardingImage = UIImageView()
    private let titleLogoImage = UIImageView()
    
    // MARK: - Life Cycle
    
    init(onboardType: OnboardingType) {
        self.onboardType = onboardType
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = onboardType.title
        onboardingImage.image = onboardType.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        changeFontLabel()
    }
}

// MARK: - Private Extensions

private extension OnboardingViewController {
    func setupStyle() {
        view.backgroundColor = .gray50
        
        titleLabel.do {
            $0.textColor = .gray800
            $0.font = .suitBold(size: 22)
            $0.textAlignment = onboardType == .fourth ? .left : .center
            $0.numberOfLines = 0
        }
        
        titleLogoImage.do {
            $0.image = UIImage(resource: .loginTitle)
            $0.contentMode = .scaleAspectFit
        }
        
        onboardingImage.do {
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setupHierarchy() {
        onboardType == .fourth ? view.addSubviews(titleLabel, titleLogoImage, onboardingImage) : view.addSubviews(titleLabel, onboardingImage)
    }
    
    func setupLayout() {
        switch onboardType {
        case .first, .second, .third:
            titleLabel.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
            
            onboardingImage.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(16))
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(view.convertByHeightRatio(28))
                $0.height.equalTo(view.convertByHeightRatio(340))
            }
            
        case .fourth:
            titleLogoImage.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(32)
                $0.height.equalTo(39)
                $0.width.equalTo(215)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLogoImage.snp.bottom).offset(14)
                $0.leading.equalToSuperview().offset(32)
            }
            
            onboardingImage.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(view.convertByHeightRatio(8))
                $0.height.equalTo(view.convertByHeightRatio(331))
            }
        }
    }
    
    func changeFontLabel() {
        switch onboardType {
        case .first:
            titleLabel.asFont(targetString: "복사한 링크", font: .suitExtraBold(size: 22))
        case .second:
            titleLabel.asFont(targetStrings: ["타이머", "리마인드"], font: .suitExtraBold(size: 22))
        case .third:
            titleLabel.asFont(targetString: "링크 열람 현황", font: .suitExtraBold(size: 22))
        case .fourth:
            titleLabel.asFont(targetString: "토스트 먹듯이 간편하게,", font: .suitExtraBold(size: 22))
        }
    }
}

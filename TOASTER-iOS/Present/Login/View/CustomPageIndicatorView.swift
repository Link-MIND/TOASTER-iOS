//
//  CustomPageIndicatorView.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 2/21/24.
//

import UIKit

import SnapKit
import Then

final class CustomPageIndicatorView: UIView {
    
    // MARK: - Properties
    
    private var indicators: [UIView] = []
    private var currentPageIndex = 0 {
        didSet {
            unselectIndicator(index: oldValue)
            selectIndicator(index: self.currentPageIndex)
        }
    }
    
    // MARK: - UI Properties
    
    private let currentIndicator = UIView()
    private let anotherIndicator = UIView()
    private let horizontalStackView = UIStackView()

    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        createCircleButton()
        selectIndicator(index: currentPageIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension CustomPageIndicatorView {
    func setupStyle() {
        backgroundColor = .gray50
        
        horizontalStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .center
            $0.spacing = 6
        }
        
        currentIndicator.do {
            $0.makeRounded(radius: self.frame.height / 2)
            $0.backgroundColor = .toasterPrimary
        }
        
        anotherIndicator.do {
            $0.makeRounded(radius: self.frame.height / 2)
            $0.backgroundColor = .gray150
        }
    }
    
    func setupHierarchy() {
        addSubviews(horizontalStackView)
    }
    
    func setupLayout() {
        horizontalStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    func createCircleButton() {
        for _ in 0..<OnboardingType.allCases.count {
            let newIndicator = UIView()
            newIndicator.backgroundColor = .gray150
            newIndicator.makeRounded(radius: 4)
            newIndicator.clipsToBounds = true
            
            newIndicator.snp.makeConstraints {
                $0.height.equalTo(8)
                $0.width.equalTo(8)
            }
            
            indicators.append(newIndicator)
        }
        
        for indicator in indicators {
            horizontalStackView.addArrangedSubview(indicator)
        }
    }
    
    func selectIndicator(index: Int) {
        indicators[index].backgroundColor = .toasterPrimary
        indicators[index].snp.updateConstraints {
            $0.width.equalTo(16)
        }
    }
    
    func unselectIndicator(index: Int) {
        indicators[index].backgroundColor = .gray150
        indicators[index].snp.updateConstraints {
            $0.width.equalTo(8)
        }
    }
}

// MARK: - Extension

extension CustomPageIndicatorView {
    func changeCurrentPageIndex(index: Int) {
        currentPageIndex = index
    }
}

//
//  RemindCollectionHeaderView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class RemindCollectionHeaderView: UICollectionReusableView {
        
    // MARK: - Properties
    
    private var timerCount: Int = 0 {
        didSet {
            countLabel.text = "\(timerCount)"
            if timerCount == 0 {
                setupCountLabelZero()
            } else {
                setupCountLabelNonZero()
            }
        }
    }
    
    // MARK: - UI Properties
    
    private let mainStackView: UIStackView = UIStackView()
    private let titleLabel: UILabel = UILabel()
    private let countView: UIView = UIView()
    private let countLabel: UILabel = UILabel()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension RemindCollectionHeaderView {
    func configureHeader(forTitle: String, 
                         forTimerCount: Int? = nil,
                         forCountLabelHidden: Bool) {
        titleLabel.text = forTitle
        if let count = forTimerCount { timerCount = count }
        countView.isHidden = forCountLabelHidden
    }
}

// MARK: - Private Extension

private extension RemindCollectionHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        mainStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        titleLabel.do {
            $0.font = .suitBold(size: 18)
            $0.textColor = .black900
        }
        
        countView.do {
            $0.isHidden = true
            $0.backgroundColor = .toasterPrimary
            $0.makeRounded(radius: 9)
        }
        
        countLabel.do {
            $0.font = .suitBold(size: 12)
            $0.textColor = .toasterWhite
        }
    }
    
    func setupHierarchy() {
        addSubviews(mainStackView)
        mainStackView.addArrangedSubviews(titleLabel, countView)
        countView.addSubview(countLabel)
    }
    
    func setupLayout() {
        mainStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        countView.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        countLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupCountLabelZero() {
        countView.backgroundColor = .gray100
        countLabel.textColor = .gray300
    }
    
    func setupCountLabelNonZero() {
        countView.backgroundColor = .toasterPrimary
        countLabel.textColor = .toasterWhite
    }
}

//
//  ToasterPillToggleControl.swift
//  TOASTER-iOS
//
//  Created by mini on 8/25/25.
//

import UIKit

import SnapKit

final class ToasterPillToggleControl: UIView {
    
    enum Segment: Int {
        case first = 0
        case second = 1
    }
    
    struct Configuration {
        var cornerRadius: CGFloat = 12
        var spacing: CGFloat = 6
        var contentInset: NSDirectionalEdgeInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        var selectedBackground: UIColor = .gray800
        var selectedTitle: UIColor = .toasterWhite
        var deselectedBackground: UIColor = .gray100
        var deselectedTitle: UIColor = .gray500
    }
    
    // MARK: - Properties
    
    private(set) var selectedSegment: Segment = .first {
        didSet {
            
        }
    }
    var onValueChanged: ((Segment) -> Void)?
    
    // MARK: - UI Components
    
    private let containerStackView = UIStackView()
    private let firstButton = UIButton()
    private let secondButton = UIButton()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ToasterPillToggleControl {
}

// MARK: - Private Extensions

private extension ToasterPillToggleControl {
    func setupStyle() {
        containerStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
        }
        
        [firstButton, secondButton].forEach {
            $0.titleLabel?.font = .suitBold(size: 14)
        }
    }
    
    func setupHierarchy() {
        addSubview(containerStackView)
        containerStackView.addSubviews(firstButton, secondButton)
    }
    
    func setupLayout() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

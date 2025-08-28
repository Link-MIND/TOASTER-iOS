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
        
        var toggled: Segment { self == .first ? .second : .first }
    }
    
    // MARK: - Properties
    
    private(set) var selectedSegment: Segment = .first {
        didSet {
            guard oldValue != selectedSegment else { return }
            updateSelectionUI()
            onValueChanged?(selectedSegment)
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
    
    convenience init(
        firstTitle: String,
        secondTitle: String
    ) {
        self.init(frame: .zero)
        firstButton.setTitle(firstTitle, for: .normal)
        secondButton.setTitle(secondTitle, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ToasterPillToggleControl {
    func setSelected(_ segment: Segment) {
        selectedSegment = segment
    }
}

// MARK: - Private Extensions

private extension ToasterPillToggleControl {
    func setupStyle() {
        containerStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 6
        }
        
        [firstButton, secondButton].forEach {
            $0.titleLabel?.font = .suitBold(size: 14)
            $0.layer.cornerRadius = 12
            $0.configuration?.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 12,
                bottom: 8,
                trailing: 12
            )
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        updateSelectionUI()
    }
    
    func setupHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(firstButton)
        containerStackView.addArrangedSubview(secondButton)
    }
    
    func setupLayout() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateSelectionUI() {
        let selected = selectedSegment == .first ? firstButton : secondButton
        let deselected = selectedSegment == .first ? secondButton : firstButton

        selected.backgroundColor = .gray800
        selected.setTitleColor(.toasterWhite, for: .normal)

        deselected.backgroundColor = .gray100
        deselected.setTitleColor(.gray500, for: .normal)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        selectedSegment = (sender == firstButton) ? .first : .second
    }
}

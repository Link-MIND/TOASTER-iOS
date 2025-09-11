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
            firstButton.isSelected  = (selectedSegment == .first)
            secondButton.isSelected = (selectedSegment == .second)
            firstButton.setNeedsUpdateConfiguration()
            secondButton.setNeedsUpdateConfiguration()
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
        firstButton.configuration?.title = firstTitle
        secondButton.configuration?.title = secondTitle
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
            $0.distribution = .fillProportionally
            $0.spacing = 6
        }
        
        firstButton.isSelected = true
        [firstButton, secondButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            var config = UIButton.Configuration.filled()
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
            config.background.cornerRadius = 8
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var out = incoming
                out.font = .suitBold(size: 12)
                return out
            }
            $0.configurationUpdateHandler = { button in
                var config = button.configuration
                config?.baseBackgroundColor = button.isSelected ? .gray800 : .gray100
                config?.baseForegroundColor = button.isSelected ? .toasterWhite : .gray500
                button.configuration = config
            }
            $0.configuration = config
        }
    }
    
    func setupHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(firstButton)
        containerStackView.addArrangedSubview(secondButton)
    }
    
    func setupLayout() {
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        selectedSegment = (sender == firstButton) ? .first : .second
    }
}

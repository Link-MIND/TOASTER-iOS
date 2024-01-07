//
//  DetailClipSegmentedControlView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/7/24.
//

import UIKit

import SnapKit
import Then

protocol DetailClipSegmentedDelegate: AnyObject {
    func setupAllLink()
    func setupReadLink()
    func setupNotReadLink()
}

final class DetailClipSegmentedControlView: UIView {
        
    // MARK: - UI Components
    
    private let readSegmentedControl = UISegmentedControl()
    var detailClipSegmentedDelegate: DetailClipSegmentedDelegate?
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension DetailClipSegmentedControlView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        readSegmentedControl.do {
            $0.insertSegment(withTitle: "전체", at: 0, animated: true)
            $0.insertSegment(withTitle: "열람", at: 1, animated: true)
            $0.insertSegment(withTitle: "미열람", at: 2, animated: true)
            $0.selectedSegmentIndex = 0
            $0.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black850,
                NSAttributedString.Key.font: UIFont.suitBold(size: 14)
            ], for: .selected)
            $0.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.gray400,
                NSAttributedString.Key.font: UIFont.suitSemiBold(size: 14)
            ], for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(readSegmentedControl)
    }
    
    func setupLayout() {
        readSegmentedControl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupAddTarget() {
        readSegmentedControl.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
    }
    
    @objc
    func didChangeValue(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            detailClipSegmentedDelegate?.setupAllLink()
        case 1:
            detailClipSegmentedDelegate?.setupReadLink()
        default:
            detailClipSegmentedDelegate?.setupNotReadLink()
        }
    }
}

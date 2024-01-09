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
    
    // MARK: - Properties
    
    var detailClipSegmentedDelegate: DetailClipSegmentedDelegate?
        
    // MARK: - UI Components
    
    private let readSegmentedControl = UISegmentedControl()
    
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
            $0.insertSegment(withTitle: StringLiterals.Clip.Segment.all, at: 0, animated: true)
            $0.insertSegment(withTitle: StringLiterals.Clip.Segment.read, at: 1, animated: true)
            $0.insertSegment(withTitle: StringLiterals.Clip.Segment.unread, at: 2, animated: true)
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
            $0.top.equalToSuperview()
            $0.height.equalTo(38)
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

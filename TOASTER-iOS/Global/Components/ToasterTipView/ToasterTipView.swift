//
//  ToasterTipView.swift
//  TOASTER-iOS
//
//  Created by 민 on 10/11/24.
//

import UIKit

import SnapKit

final class ToasterTipView: UIView {
    
    // MARK: - Properties
    
    private let title: String
    private let tipType: TipType
    
    // MARK: - UI Components
    
    private let sourceView: UIView
    
    private let containerView = UIView()
    private let tipLabel = UILabel()
    private lazy var tipPathView = TipPathView(tipType: tipType)
    
    // MARK: - Life Cycles
    
    init(title: String, type: TipType, sourceItem: UIView) {
        self.title = title
        self.tipType = type
        self.sourceView = sourceItem
        super.init(frame: .zero)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ToasterTipView {
    /// 툴팁을 보여줄 때 호출하는 함수
    func showTooltip() {
        switch tipType {
        case .top:
            self.snp.makeConstraints {
                $0.bottom.equalTo(sourceView.snp.top).offset(-8)
                $0.centerX.equalTo(sourceView.snp.centerX)
            }
        case .bottom:
            self.snp.makeConstraints {
                $0.top.equalTo(sourceView.snp.bottom).offset(8)
                $0.centerX.equalTo(sourceView.snp.centerX)
            }
        case .left:
            self.snp.makeConstraints {
                $0.right.equalTo(sourceView.snp.left).offset(-8)
                $0.centerY.equalTo(sourceView.snp.centerY)
            }
        case .right:
            self.snp.makeConstraints {
                $0.left.equalTo(sourceView.snp.right).offset(8)
                $0.centerY.equalTo(sourceView.snp.centerY)
            }
        }
    }
}


// MARK: - Private Extensions

private extension ToasterTipView {
    func setupStyle() {
        backgroundColor = .clear
        
        tipPathView.do {
            $0.backgroundColor = .clear
        }
        
        containerView.do {
            $0.backgroundColor = .black900
            $0.makeRounded(radius: 8)
        }
        
        tipLabel.do {
            $0.text = title
            $0.font = .suitMedium(size: 12)
            $0.textColor = .toasterWhite
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        addSubviews(tipPathView, containerView)
        containerView.addSubviews(tipLabel)
    }
    
    func setupLayout() {
        tipPathView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(9)
        }
        
        tipLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}

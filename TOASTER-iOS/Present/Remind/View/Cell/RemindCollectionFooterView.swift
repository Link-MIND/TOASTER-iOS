//
//  RemindCollectionFooterView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class RemindCollectionFooterView: UICollectionReusableView {
        
    // MARK: - UI Properties
    
    private let dividingView: UIView = UIView()

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

// MARK: - Private Extension

private extension RemindCollectionFooterView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        dividingView.do {
            $0.backgroundColor = .gray50
        }
    }
    
    func setupHierarchy() {
        addSubview(dividingView)
    }
    
    func setupLayout() {
        dividingView.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.top.horizontalEdges.equalToSuperview()
        }
    }
}

//
//  AddClipBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class AddClipBottomSheetView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let addClipTextField = UITextField()
    
    private let addClipButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.tintColor = .toasterPrimary
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension AddClipBottomSheetView {
    func setupDataBind() {
        
    }
}

// MARK: - Private Extensions

private extension AddClipBottomSheetView {
    func setupStyle() {
        backgroundColor = .black850
    }
    
    func setupHierarchy() {
        
    }
    
    func setupLayout() {
        
    }
    
    func setupCell() {
        
    }
    
    func setupAddTarget() {
        
    }
    
    @objc
    func buttonTapped() {
        
    }
}


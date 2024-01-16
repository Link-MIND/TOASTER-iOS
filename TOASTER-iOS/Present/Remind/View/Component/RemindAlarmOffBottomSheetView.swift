//
//  RemindAlarmOffBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

protocol RemindAlarmOffBottomSheetViewDelegate: AnyObject {
    func alarmButtonTapped()
}

final class RemindAlarmOffBottomSheetView: UIView {
    
    // MARK: - Properties

    private weak var delegate: RemindAlarmOffBottomSheetViewDelegate?
    
    // MARK: - UI Properties
    
    private let alarmOffView: RemindAlarmOffView = RemindAlarmOffView(frame: .zero, type: .bottomSheet)
    private let alarmButton: UIButton = UIButton()
    
    // MARK: - Life Cycles
    
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

extension RemindAlarmOffBottomSheetView {
    func setupDelegate(forDelegate: RemindAlarmOffBottomSheetViewDelegate) {
        delegate = forDelegate
    }
}

// MARK: - Private Extension

private extension RemindAlarmOffBottomSheetView {
    func setupStyle() {
        backgroundColor = .toasterWhite
        
        alarmButton.do {
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .toasterBlack
            $0.setTitle("알림 받을래요", for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
            $0.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(alarmOffView, alarmButton)
    }
    
    func setupLayout() {
        alarmOffView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        
        alarmButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.top.equalTo(alarmOffView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    @objc func alarmButtonTapped() {
        delegate?.alarmButtonTapped()
    }
}

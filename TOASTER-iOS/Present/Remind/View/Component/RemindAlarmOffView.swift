//
//  RemindAlarmOffView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/10/24.
//

import UIKit

import SnapKit
import Then

final class RemindAlarmOffView: UIView {
    
    // MARK: - Components

    private let viewType: RemindAlarmOffViewType

    // MARK: - UI Components
    
    private let alarmOffImageView: UIImageView = UIImageView()
    private let alarmOffLabel: UILabel = UILabel()
    private let explainLabel: UILabel = UILabel()
    
    // MARK: - Life Cycles
    
    init(frame: CGRect, type: RemindAlarmOffViewType) {
        viewType = type
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

private extension RemindAlarmOffView {
    func setupStyle() {
        backgroundColor = .clear
        
        alarmOffImageView.do {
            $0.image = .imgAlarmIos
        }
        
        alarmOffLabel.do {
            $0.numberOfLines = 0
            $0.textColor = .gray800
            $0.textAlignment = viewType.textAlignment
            $0.font = .suitRegular(size: 16)
            $0.text = "기기 알림이 꺼져있으면\n토스터의 타이머 기능을 이용할 수 없어요"
        }
        
        explainLabel.do {
            $0.numberOfLines = 0
            $0.textColor = .gray400
            $0.textAlignment = viewType.textAlignment
            $0.font = .suitRegular(size: 14)
            $0.text = viewType.bottomLabelText
        }
    }
    
    func setupHierarchy() {
        addSubviews(alarmOffLabel, alarmOffImageView, explainLabel)
    }
    
    func setupLayout() {
        alarmOffLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        alarmOffImageView.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(146)
            $0.top.equalTo(alarmOffLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
        
        explainLabel.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(alarmOffImageView.snp.bottom).offset(12)
        }
    }
}

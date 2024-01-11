//
//  RemindTimerEditBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

protocol RemindEditViewDelegate: AnyObject{
    func editTimer(forID: Int?)
    func deleteTimer(forID: Int?)
}

final class RemindTimerEditBottomSheetView: UIView {

    // MARK: - Properties

    private weak var delegate: RemindEditViewDelegate?
    private var editTimerID: Int?
    
    // MARK: - UI Properties
    
    private let editButton: UIButton = UIButton()
    private let deleteButton: UIButton = UIButton()
    
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

extension RemindTimerEditBottomSheetView {
    func setupEditView(forDelegate: RemindEditViewDelegate,
                       forID: Int?) {
        delegate = forDelegate
        editTimerID = forID
    }
}

// MARK: - Private Extension

private extension RemindTimerEditBottomSheetView {
    func setupStyle() {
        backgroundColor = .gray50
        
        editButton.do {
            $0.backgroundColor = .toasterWhite
            $0.setTitle("타이머 수정하기", for: .normal)
            $0.setTitleColor(.black900, for: .normal)
            $0.titleLabel?.font = .suitMedium(size: 16)
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.makeRounded(radius: 12)
            $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
        
        deleteButton.do {
            $0.backgroundColor = .toasterWhite
            $0.setTitle("삭제", for: .normal)
            $0.setTitleColor(.toasterError, for: .normal)
            $0.titleLabel?.font = .suitMedium(size: 16)
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.makeRounded(radius: 12)
            $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(editButton, deleteButton)
    }
    
    func setupLayout() {
        editButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.top.equalTo(editButton.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    @objc func editButtonTapped() {
        delegate?.editTimer(forID: editTimerID)
    }
    
    @objc func deleteButtonTapped() {
        delegate?.deleteTimer(forID: editTimerID)
    }
}

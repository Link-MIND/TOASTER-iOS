//
//  RemindTimerEditBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

protocol RemindEditViewDelegate: AnyObject {
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
    private let editButtonLabel: UILabel = UILabel()
    private let deleteButtonLabel: UILabel = UILabel()
    
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
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.makeRounded(radius: 12)
            $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
        
        deleteButton.do {
            $0.backgroundColor = .toasterWhite
            $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            $0.makeRounded(radius: 12)
            $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }
        
        editButtonLabel.do {
            $0.text = "수정하기"
            $0.textColor = .black900
            $0.font = .suitMedium(size: 16)
        }
        
        deleteButtonLabel.do {
            $0.text = StringLiterals.Button.delete
            $0.textColor = .toasterError
            $0.font = .suitMedium(size: 16)
        }
    }
    
    func setupHierarchy() {
        addSubviews(editButton, deleteButton)
        editButton.addSubview(editButtonLabel)
        deleteButton.addSubview(deleteButtonLabel)
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
        
        [editButtonLabel, deleteButtonLabel].forEach {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
        }
    }
    
    @objc func editButtonTapped() {
        delegate?.editTimer(forID: editTimerID)
    }
    
    @objc func deleteButtonTapped() {
        delegate?.deleteTimer(forID: editTimerID)
    }
}

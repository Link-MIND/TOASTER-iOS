//
//  EditClipCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class EditClipCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var leadingButtonAction: (() -> Void)?
    private var changeTitleButtonAction: (() -> Void)?
        
    // MARK: - UI Components
    
    private let leadingButton = UIButton()
    private let cellBackgroundView = UIView()
    private let clipTitleLabel = UILabel()
    private let changeTitleButton = UIButton()
    
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

// MARK: - Extensions

extension EditClipCollectionViewCell {
    func configureCell(forModel: ClipListModel, icon: UIImage, isFirst: Bool) {
        clipTitleLabel.text = forModel.categoryTitle
        leadingButton.setImage(icon, for: .normal)
        changeTitleButton.isHidden = isFirst
    }
    
    func leadingButtonTapped(_ action: @escaping () -> Void) {
        leadingButtonAction = action
    }
    
    func changeTitleButtonTapped(_ action: @escaping () -> Void) {
        changeTitleButtonAction = action
    }
}

// MARK: - Private Extensions

private extension EditClipCollectionViewCell {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        leadingButton.do {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        cellBackgroundView.do {
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .toasterWhite
        }
        
        clipTitleLabel.do {
            $0.font = .suitSemiBold(size: 16)
            $0.textColor = .black850
            $0.textAlignment = .left
            $0.text = "Text"
        }
        
        changeTitleButton.do {
            $0.setImage(ImageLiterals.Clip.edit, for: .normal)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(leadingButton, cellBackgroundView)
        cellBackgroundView.addSubviews(clipTitleLabel, changeTitleButton)
    }
    
    func setupLayout() {
        leadingButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
        
        cellBackgroundView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(leadingButton.snp.trailing).offset(8)
        }
        
        clipTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
            $0.trailing.equalTo(changeTitleButton.snp.leading).inset(-14)
        }
        
        changeTitleButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
    }
    
    @objc 
    func buttonTapped(_ sender: UIButton) {
        switch sender {
        case leadingButton:
            leadingButtonAction?()
        case changeTitleButton:
            changeTitleButtonAction?()
        default:
            break
        }
    }
}

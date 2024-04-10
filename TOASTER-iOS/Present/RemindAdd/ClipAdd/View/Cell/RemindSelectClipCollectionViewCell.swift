//
//  RemindSelectClipCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class RemindSelectClipCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                setupSelected()
            } else {
                setupDeselected()
            }
        }
    }

    var isShareExtension = false {
        didSet {
            updateRoundedStyle()
        }
    }
    
    // MARK: - UI Properties
    
    private let clipImageView: UIImageView = UIImageView(image: .icClip24Black)
    private let clipTitleLabel: UILabel = UILabel()
    private let clipCountLabel: UILabel = UILabel()
    private let separatorView = UIView()
    
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

// MARK: - Extension

extension RemindSelectClipCollectionViewCell {
    func configureCell(forModel: RemindClipModel, icon: UIImage) {
        clipTitleLabel.text = forModel.title
        clipCountLabel.text = "\(forModel.clipCount)개"
        clipImageView.image = isSelected == true ? icon.withTintColor(.toasterPrimary) : icon
    }
    
    func configureCell(forModel: SelectClipModel, icon: UIImage) {
        clipTitleLabel.text = forModel.title
        clipCountLabel.text = "\(forModel.clipCount)개"
        clipImageView.image = isSelected == true ? icon.withTintColor(.toasterPrimary) : icon
    }
    
    func configureCell(forModel: RemindClipModel, icon: UIImage, isShareExtension: Bool) {
        clipTitleLabel.text = forModel.title
        clipCountLabel.text = "\(forModel.clipCount)개"
        clipImageView.image = isSelected == true ? icon.withTintColor(.toasterPrimary) : icon
        self.isShareExtension = isShareExtension
    }
}

// MARK: - Private Extension

private extension RemindSelectClipCollectionViewCell {
    func setupStyle() {
        backgroundColor = .toasterWhite
        
        clipTitleLabel.do {
            $0.font = .suitSemiBold(size: 16)
            $0.textColor = .black850
        }
        
        clipCountLabel.do {
            $0.font = .suitSemiBold(size: 14)
            $0.textColor = .gray600
        }
        
        updateRoundedStyle()
    }
    
    func setupHierarchy() {
        addSubviews(clipImageView, clipTitleLabel, clipCountLabel)
    }
    
    func setupLayout() {
        clipImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }
        
        clipTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(clipImageView.snp.trailing).offset(4)
        }
        
        clipCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
    }
    
    func setupSelected() {
        if clipTitleLabel.text == "전체 클립" {
            clipImageView.image = .icAllClip24.withTintColor(.toasterPrimary)
        } else {
            clipImageView.image = .icClip24Black.withTintColor(.toasterPrimary)
        }
        
        [clipTitleLabel, clipCountLabel].forEach {
            $0.textColor = .toasterPrimary
        }
    }
    
    func setupDeselected() {
        if clipTitleLabel.text == "전체 클립" {
            clipImageView.image = .icAllClip24
        } else {
            clipImageView.image = .icClip24Black
        }

        clipTitleLabel.textColor = .toasterBlack
        clipCountLabel.textColor = .gray600
    }
    
    func updateRoundedStyle() {
        if isShareExtension {
            makeRounded(radius: 0)
        } else {
            makeRounded(radius: 12)
        }
    }
}

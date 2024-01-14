//
//  SelectClipView.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/15.
//

import UIKit

import SnapKit
import Then

final class SelectClipCollectionViewCell: UICollectionViewCell {
    
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
    
    // MARK: - UI Properties
    
    private let clipImageView: UIImageView = UIImageView(image: ImageLiterals.Clip.clipIcon)
    private let clipTitleLabel: UILabel = UILabel()
    private let clipCountLabel: UILabel = UILabel()
    
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

extension SelectClipCollectionViewCell {
    func configureCell(forModel: RemindClipModel) {
        clipTitleLabel.text = forModel.title
        clipCountLabel.text = "\(forModel.clipCount)개"
    }
}

// MARK: - Private Extension

private extension SelectClipCollectionViewCell {
    func setupStyle() {
        backgroundColor = .toasterWhite
        makeRounded(radius: 12)
        
        clipTitleLabel.do {
            $0.font = .suitSemiBold(size: 16)
            $0.textColor = .black850
        }
        
        clipCountLabel.do {
            $0.font = .suitSemiBold(size: 14)
            $0.textColor = .gray600
        }
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
        clipImageView.image = ImageLiterals.Clip.clipIcon.withTintColor(.toasterPrimary)
        [clipTitleLabel, clipCountLabel].forEach {
            $0.textColor = .toasterPrimary
        }
    }
    
    func setupDeselected() {
        clipImageView.image = ImageLiterals.Clip.clipIcon
        clipTitleLabel.textColor = .toasterBlack
        clipCountLabel.textColor = .gray600
    }
    
}

//
//  DetailClipListCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/7/24.
//

import UIKit

import SnapKit
import Then

final class DetailClipListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    lazy var isClipNameLabelHidden: Bool = clipNameLabel.isHidden {
        didSet {
            setupLayout()
        }
    }
    var detailClipListCollectionViewCellButtonAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let linkImage = UIImageView()
    private let clipNameLabel = UILabel()
    private let linkTitleLabel = UILabel()
    private let linkLabel = UILabel()
    private let modifiedButton = UIButton()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DetailClipListCollectionViewCell {
    func configureCell(forModel: ToastList) {
        linkTitleLabel.text = forModel.toastTitle
        linkLabel.text = forModel.linkURL
        isClipNameLabelHidden = forModel.isRead
    }
}

// MARK: - Private Extensions

private extension DetailClipListCollectionViewCell {
    func setupStyle() {
        backgroundColor = .toasterWhite
        makeRounded(radius: 12)
        
        linkImage.do {
            $0.makeRounded(radius: 8)
            $0.image = ImageLiterals.Clip.thumb
        }
        
        clipNameLabel.do {
            $0.text = "세부 클립명"
            $0.backgroundColor = .toaster50
            $0.makeRounded(radius: 8)
            $0.textColor = .toasterPrimary
            $0.font = .suitMedium(size: 10)
            $0.textAlignment = .center
        }
        
        linkTitleLabel.do {
            $0.font = .suitMedium(size: 16)
            $0.textColor = .black850
            $0.text = "타이틀어쩌구"
        }
        
        linkLabel.do {
            $0.font = .suitMedium(size: 10)
            $0.textColor = .gray200
            $0.text = "https://linklinklink"
        }
        
        modifiedButton.do {
            $0.setImage(ImageLiterals.Clip.meatballs, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(linkImage, clipNameLabel, linkTitleLabel, linkLabel, modifiedButton)
    }
    
    func setupLayout() {
        linkImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(74)
        }
        
        linkLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(linkImage.snp.trailing).offset(12)
        }
        
        modifiedButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(4)
            $0.top.equalToSuperview().inset(4)
        }
        
        clipNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalTo(linkImage.snp.trailing).offset(12)
            $0.height.equalTo(20)
            $0.width.equalTo(clipNameLabel.intrinsicContentSize.width+16)
        }
        
        linkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(clipNameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(linkImage.snp.trailing).offset(12)
        }
        
        if isClipNameLabelHidden {
            clipNameLabel.isHidden = true
            linkTitleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.leading.equalTo(linkImage.snp.trailing).offset(12)
            }
        }
    }
    
    func setupAddTarget() {
        modifiedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc
    func buttonTapped() {
        detailClipListCollectionViewCellButtonAction?()
    }
}

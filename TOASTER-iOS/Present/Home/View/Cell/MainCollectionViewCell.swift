//
//  MainCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//
import UIKit

import SnapKit
import Then

protocol MainCollectionViewDelegate: AnyObject {
    func searchButtonTapped()
}

// MARK: - main section

final class MainCollectionViewCell: UICollectionViewCell {
    
    weak var mainCollectionViewDelegate: MainCollectionViewDelegate?
    
    // MARK: - UI Components
    
    private let searchButton = UIButton()
    private let userLabel = UILabel()
    private let noticeLabel = UILabel()
    private let countToastLabel = UILabel()
    lazy var linkProgressView = UIProgressView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Make View
    
    func setView() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

extension MainCollectionViewCell {
    func bindData(forModel: MainInfoModel) {
        userLabel.text = "\(forModel.nickname)님"
        userLabel.asFont(targetString: forModel.nickname, font: .suitBold(size: 20))
        noticeLabel.text = "토스터로 " + String(forModel.readToastNum) + "개의 링크를\n잊지 않고 읽었어요!"
        noticeLabel.asFontColor(targetString: String(forModel.readToastNum) + "개의 링크", font: .suitExtraBold(size: 20), color: .toasterPrimary)
        
        countToastLabel.text = String(forModel.readToastNum) + " / " + String(forModel.allToastNum)
        countToastLabel.asFontColor(targetString: String(forModel.readToastNum), font: .suitBold(size: 20), color: .toasterPrimary)
        
        if forModel.readToastNum == 0 && forModel.allToastNum == 0 {
            linkProgressView.setProgress(0.0, animated: true)
        } else {
            linkProgressView.setProgress(Float(forModel.readToastNum)/Float(forModel.allToastNum), animated: true)
        }
    }
}

// MARK: - Private Extensions

private extension MainCollectionViewCell {
    func setupStyle() {
        searchButton.do {
            $0.makeRounded(radius: 12)
            $0.setImage(ImageLiterals.Home.searchIcon, for: .normal)
            $0.setTitle(StringLiterals.Placeholder.search, for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.font = .suitRegular(size: 16)
            $0.contentHorizontalAlignment = .left
            $0.imageView?.contentMode = .scaleAspectFit
            $0.semanticContentAttribute = .forceLeftToRight
            var configuration = UIButton.Configuration.filled()
            configuration.imagePadding = 8
            configuration.baseBackgroundColor = .gray50
            $0.configuration = configuration
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        userLabel.do {
            $0.font = .suitRegular(size: 20)
            $0.textColor = .black900
        }
        
        noticeLabel.do {
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 4)
            $0.textAlignment = .left
            $0.font = .suitRegular(size: 20)
            $0.textColor = .black900
        }
        
        countToastLabel.do {
            $0.font = .suitRegular(size: 16)
            $0.textColor = .gray300
        }
        
        linkProgressView.do {
            $0.trackTintColor = .gray100
            $0.progressTintColor = .toasterPrimary
            $0.makeRounded(radius: 6)
            $0.clipsToBounds = true
            $0.subviews[1].makeRounded(radius: 6)
        }
    }
    
    func setupHierarchy() {
        addSubviews(searchButton, userLabel, noticeLabel, countToastLabel, linkProgressView)
    }
    
    func setupLayout() {
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        userLabel.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(userLabel.snp.bottom).offset(5)
            $0.leading.equalTo(userLabel.snp.leading)
        }
        
        countToastLabel.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(userLabel.snp.leading)
        }
        
        linkProgressView.snp.makeConstraints {
            $0.top.equalTo(countToastLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(12)
        }
    }
    
    @objc func buttonTapped() {
        mainCollectionViewDelegate?.searchButtonTapped()
    }
    
}

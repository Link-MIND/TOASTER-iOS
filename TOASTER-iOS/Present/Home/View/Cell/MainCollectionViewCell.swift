//
//  MainCollectionViewCell.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/09.
//
import UIKit

import SnapKit
import Then

// MARK: - main section

final class MainCollectionViewCell: UICollectionViewCell {
    
//    private var nickName: String = String()
//    private var readToastNum: Int = Int()
//    private var allToastNum: Int = Int()
    
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
        userLabel.text = forModel.nickname + StringLiterals.Home.Main.subNickName
        
        noticeLabel.text = "토스터로 " + String(forModel.allToastNum) + "개의 링크를 \n잊지 않고 읽었어요!"
        noticeLabel.asFontColor(targetString: String(forModel.allToastNum) + "개의 링크", font: .suitExtraBold(size: 20), color: .toasterPrimary)
        
        countToastLabel.text = String(forModel.readToastNum) + " / " + String(forModel.allToastNum)
        countToastLabel.asFontColor(targetString: String(forModel.readToastNum), font: .suitBold(size: 20), color: .toasterPrimary)
        
        linkProgressView.progress = Float(forModel.readToastNum)/Float(forModel.allToastNum)
    }
}

// MARK: - Private Extensions

private extension MainCollectionViewCell {
    func setupStyle() {
        searchButton.do {
            $0.makeRounded(radius: 12)
            $0.setImage(ImageLiterals.Home.searchIcon, for: .normal)
            $0.setTitle(StringLiterals.Home.Main.searchPlaceHolder, for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.font = .suitRegular(size: 16)
            $0.contentHorizontalAlignment = .left
            $0.imageView?.contentMode = .scaleAspectFit
            $0.semanticContentAttribute = .forceLeftToRight
            var configuration = UIButton.Configuration.filled()
            configuration.imagePadding = 8
            configuration.baseBackgroundColor = .gray50
            $0.configuration = configuration
        }
        
        userLabel.do {
           // $0.text = nickName + StringLiterals.Home.Main.subNickName
            $0.font = .suitBold(size: 20)
            $0.textColor = .black900
            $0.asFont(targetString: StringLiterals.Home.Main.subNickName, font: .suitRegular(size: 20))
        }
        
        noticeLabel.do {
          //  $0.text = "토스터로 " + String(allToastNum) + "개의 링크를 \n잊지 않고 읽었어요!"
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 4)
            $0.textAlignment = .left
            $0.font = .suitRegular(size: 20)
            $0.textColor = .black900
           // $0.asFontColor(targetString: String(allToastNum) + "개의 링크", font: .suitExtraBold(size: 20), color: .toasterPrimary)
        }
        
        countToastLabel.do {
            $0.font = .suitRegular(size: 16)
            $0.textColor = .gray300
        }
        
        linkProgressView.do {
            $0.trackTintColor = .gray100
            $0.progressTintColor = .toasterPrimary
        //    $0.progress = Float(readToastNum)/Float(allToastNum)
            $0.makeRounded(radius: 8)
            $0.clipsToBounds = true
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
            $0.leading.equalToSuperview().inset(20)
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
            $0.leading.equalTo(userLabel.snp.leading)
            $0.width.equalTo(335)
            $0.height.equalTo(12)
        }
    }
}

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
    
    var nickName: String = "김가현"
    var readToastNum: Int = 13
    var allToastNum: Int = 47
    
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


private extension MainCollectionViewCell {
    
    func setupStyle() {
        searchButton.do {
            $0.backgroundColor = .gray50
            $0.setTitle("검색어를 입력해주세요.", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.layer.cornerRadius = 12
        }
        
        userLabel.do {
            $0.text = nickName + "님"
            $0.font = .suitBold(size: 20)
            $0.textColor = .black900
            $0.asFont(targetString: "님", font: .suitRegular(size: 20))
        }
        
        noticeLabel.do {
            $0.text = "토스터로 " + String(allToastNum) + "개의 링크를 \n잊지 않고 읽었어요!"
            $0.numberOfLines = 2
            $0.textAlignment = .left
            $0.font = .suitRegular(size: 20)
            $0.textColor = .black900
            $0.asFontColor(targetString: String(allToastNum) + "개의 링크", font: .suitExtraBold(size: 20), color: .toasterPrimary)
        }
        
        countToastLabel.do {
            $0.text = String(readToastNum) + "/" + String(allToastNum)
            $0.font = .suitRegular(size: 16)
            $0.textColor = .gray300
            $0.asColor(targetString: String(readToastNum), color: .red)
            $0.asFontColor(targetString: String(readToastNum), font: .suitBold(size: 20), color: .toasterPrimary)
        }
        
        linkProgressView.do {
            $0.trackTintColor = .gray100
            $0.progressTintColor = .toasterPrimary
            $0.progress = Float(readToastNum)/Float(allToastNum)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        addSubviews(searchButton, userLabel, noticeLabel, countToastLabel, linkProgressView)
    }
    
    func setupLayout() {
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(42)
            $0.centerX.equalToSuperview()
        }
        
        userLabel.snp.makeConstraints {
            $0.top.equalTo(searchButton.snp.bottom).offset(42)
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

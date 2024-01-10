//
//  MypageHeaderView.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/10/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MypageHeaderView: UIView {
    
    // MARK: - Properties
    
    private let userName: String
        
    // MARK: - UI Components
    
    private let profileImageView = UIImageView()
    
    private let subTitleStackView = UIStackView()
    private let topSubTitleLabel = UILabel()
    private let bottomSubTitleLabel = UILabel()
    
    private let readLinkStackView = UIStackView()
    private let readLinkCountLabel = UILabel()
    private let readLinkCountUnitLabel = UILabel()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MypageHeaderView {
    func bindModel(model: MypageUserModel) {
        topSubTitleLabel.attributedText = changeFontColor(text: model.nickname)
        readLinkCountLabel.text = "\(model.allReadToast)"
    }
}

// MARK: - Private Extensions

private extension MypageHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        subTitleStackView.do {
            $0.spacing = 2
            $0.axis = .vertical
        }
        
        topSubTitleLabel.do {
            $0.font = .suitBold(size: 28)
            $0.textColor = .toasterPrimary
        }
        
        bottomSubTitleLabel.do {
            $0.font = .suitMedium(size: 16)
            $0.textColor = .black900
        }
        
        readLinkStackView.do {
            $0.spacing = 3
            $0.axis = .horizontal
        }
        
        readLinkCountLabel.do {
            $0.font = .suitBold(size: 28)
            $0.textColor = .toasterPrimary
        }
        
        readLinkCountUnitLabel.do {
            $0.text = StringLiterals.Mypage.Title.bottomTitle
            $0.font = .suitMedium(size: 16)
            $0.textColor = .black900
        }
    }
    
    func setupHierarchy() {
        addSubviews(readLinkStackView)
        
        subTitleStackView.addArrangedSubviews(topSubTitleLabel, bottomSubTitleLabel)
        readLinkStackView.addArrangedSubviews(readLinkCountLabel, readLinkCountUnitLabel)
    }
    
    func setupLayout() {
        
    }
    
    func changeFontColor(text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)

        attributedString.addAttribute(.foregroundColor, value: UIColor.black900, range: NSRange(location: 0, length: 5))
                
        // 유저 이름에 다른 폰트 적용
        attributedString.addAttribute(.font, value: UIFont.suitBold(size: 18), range: NSRange(location: 0, length: 3))
        
        // '님이'에 다른 폰트 적용
        attributedString.addAttribute(.font, value: UIFont.suitMedium(size: 18), range: NSRange(location: 3, length: 2))
        
        return attributedString
    }
}

//
//  ClipCollectionHeaderView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

protocol ClipCollectionHeaderViewDelegate: AnyObject {
    func addClipButtonTapped()
    func searchBarButtonTapped()
}

final class ClipCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var clipCollectionHeaderViewDelegate: ClipCollectionHeaderViewDelegate?
    
    // MARK: - UI Components
    
    private let searchBarButton = UIButton()
    private let clipCountLabel = UILabel()
    private let addClipButton = UIButton()
    
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

extension ClipCollectionHeaderView {
    func isDetailClipView(isHidden: Bool) {
        searchBarButton.isHidden = isHidden
        addClipButton.isHidden = isHidden
        
        if isHidden {
            clipCountLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().inset(20)
            }
        }
    }
    
    func setupDataBind(count: Int) {
        clipCountLabel.text = "전체 (\(count))"
    }
}

// MARK: - Private Extensions

private extension ClipCollectionHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        searchBarButton.do {
            $0.setImage(ImageLiterals.Clip.searchbar, for: .normal)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        
        clipCountLabel.do {
            $0.textColor = .gray500
            $0.font = .suitBold(size: 12)
            $0.text = "전체 (n)"
        }
        
        addClipButton.do {
            $0.setImage(ImageLiterals.Clip.orangeplus, for: .normal)
            $0.setTitle(StringLiterals.Clip.Title.addClip, for: .normal)
            $0.setTitleColor(.toasterPrimary, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 12)
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(searchBarButton, clipCountLabel, addClipButton)
    }
    
    func setupLayout() {
        searchBarButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        clipCountLabel.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        addClipButton.snp.makeConstraints {
            $0.top.equalTo(searchBarButton.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        switch sender {
        case searchBarButton:
            clipCollectionHeaderViewDelegate?.searchBarButtonTapped()
        case addClipButton:
            clipCollectionHeaderViewDelegate?.addClipButtonTapped()
        default:
            break
        }
    }
}

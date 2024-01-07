//
//  ClipCollectionHeaderView.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/4/24.
//

import UIKit

import SnapKit
import Then

final class ClipCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    
    private let searchBar = UIImageView()
    private let clipCountLabel = UILabel()
    private let addClipButton = UIButton()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupAddTarget()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ClipCollectionHeaderView {
    func isaddClipButtonHidden() {
        addClipButton.isHidden = true
    }
    
    func setupDataBind(count: Int) {
        clipCountLabel.text = "전체 (\(count))"
    }
}

// MARK: - Private Extensions

private extension ClipCollectionHeaderView {
    func setupStyle() {
        backgroundColor = .toasterBackground
        
        searchBar.do {
            $0.image = ImageLiterals.Clip.searchbar 
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
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
        }
    }
    
    func setupHierarchy() {
        addSubviews(searchBar, clipCountLabel, addClipButton)
    }
    
    func setupLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        clipCountLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        addClipButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupAddTarget() {
        addClipButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    /// 뷰 컨트롤러 찾기
    /// UICollectionReusableView는 뷰컨 윈도우 계층에 직접적으로 속해있지 않기 때문에 present를 못함. present할 뷰컨의 속성을 찾기 위한 함수
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    @objc
    func buttonTapped() {
        guard let viewController = findViewController() else { return }
        let view = AddClipBottomSheetView()        
        let exampleBottom = ToasterBottomSheetViewController(bottomType: .white, bottomTitle: "클립 추가", height: keyboardLayoutGuide.layoutFrame.height-137+(keyboardLayoutGuide.owningView?.frame.height ?? 0), insertView: view)
        exampleBottom.modalPresentationStyle = .overFullScreen
        viewController.present(exampleBottom, animated: false)
    }
}

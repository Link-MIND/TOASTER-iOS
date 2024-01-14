//
//  MypageViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class MypageViewController: UIViewController {

    // MARK: - UI Properties
    
    private let mypageHeaderView = MypageHeaderView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        mypageHeaderView.bindModel(model: MypageUserModel(nickname: "홍길동", profile: nil, allReadToast: 5, thisWeekendRead: 3, thisWeekendSaved: 7))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

// MARK: - Private Extensions

private extension MypageViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
    }
    
    func setupHierarchy() {
        view.addSubview(mypageHeaderView)
    }
    
    func setupLayout() {
        mypageHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string(StringLiterals.Tabbar.Title.my),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.setting),
                                                                rightButtonAction: settingButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
        
    func settingButtonTapped() {
        // 편집 버튼 클릭 시 로직 ( 로그아웃 기능을 확인하고자 임시로 로직을 추가 함 )
        
        let result = KeyChainService.deleteAccessToken(key: Config.accessTokenKey)
    }
}

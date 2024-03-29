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
    private let mypageAlertView = MypageAlertView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        fetchMypageInformation()
    }
}

// MARK: - Private Extensions

private extension MypageViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
    }
    
    func setupHierarchy() {
        view.addSubviews(mypageHeaderView, mypageAlertView)
    }
    
    func setupLayout() {
        mypageHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        mypageAlertView.snp.makeConstraints {
            $0.top.equalTo(mypageHeaderView.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview()
        }
    }

    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string(StringLiterals.Tabbar.my),
                                                                rightButton: StringOrImageType.image(.icSettings24),
                                                                rightButtonAction: settingButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
        
    func settingButtonTapped() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func fetchMypageInformation() {
        NetworkService.shared.userService.getMyPage { [weak self] result in
            switch result {
            case .success(let response):
                if let responseData = response?.data {
                    DispatchQueue.main.async { [weak self] in
                        self?.mypageHeaderView.bindModel(model: MypageUserModel(nickname: responseData.nickname,
                                                                                profile: responseData.profile,
                                                                                allReadToast: responseData.allReadToast,
                                                                                thisWeekendRead: responseData.thisWeekendRead,
                                                                                thisWeekendSaved: responseData.thisWeekendSaved))
                    }
                }
            case .unAuthorized, .networkFail:
                self?.changeViewController(viewController: LoginViewController())
            default:
                print("default Fail")
            }
        }
    }
}

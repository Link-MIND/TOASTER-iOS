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
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Properties

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
//        setupLayout()
//        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        setupNavigationBar()
    }
}
//// MARK: - Networks
//
//extension MypageViewController {
//    func fetchMain() {
//        <#code#>
//    }
//}
// MARK: - Private Extensions

private extension MypageViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
    }
    
    func setupHierarchy() {
        view.addSubviews()
    }
    
    func setupLayout() {
        <#code#>
    }
    
    func setupDelegate() {
        <#code#>
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
        // 편집 버튼 클릭 시 로직
    }
}

//
//  AddLinkViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class AddLinkViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private var addLinkView = AddLinkView()
     
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .toasterBackground

        super.tabBarController?.tabBar.isHidden = true
        
        setAddLinkVew()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         setupNavigationBar()
     }
    
    // MARK: - set up Add Link View
    
    private func setAddLinkVew() {
        view.addSubview(addLinkView)
        
        addLinkView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Private extension

private extension AddLinkViewController {
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string("링크 저장"),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.close),
                                                                rightButtonAction: closeButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func closeButtonTapped() {
        let closeAddLinkViewController = HomeViewController()
        closeAddLinkViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.popViewController(animated: false)
    }
}

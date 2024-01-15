//
//  AddLinkViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

protocol SaveLinkButtonDelegate: AnyObject {
    func saveLinkButtonTapped()
    func cancleLinkButtonTapped()
}

final class AddLinkViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private var addLinkView = AddLinkView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setAddLinkVew()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()

        resetView()
    }
    
    // MARK: - set up Add Link View
    
    private func setAddLinkVew() {
        view.addSubview(addLinkView)
        
        addLinkView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addLinkView.nextBottomButton.addTarget(self, action: #selector(tappedNextBottomButton), for: .touchUpInside)
        addLinkView.nextTopButton.addTarget(self, action: #selector(tappedNextBottomButton), for: .touchUpInside)
    }
}

// MARK: - Private extension

private extension AddLinkViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
    }
    
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
    
    func resetView() {
        addLinkView.linkEmbedTextField.text = nil
    }
    
    func closeButtonTapped() {
        showPopup(forMainText: "링크 저장을 취소하시겠어요?",
                  forSubText: "저장 중인 링크가 사라져요",
                  forLeftButtonTitle: "닫기",
                  forRightButtonTitle: "삭제",
                  forRightButtonHandler: rightButtonTapped)
    }
    
    func rightButtonTapped() {
        dismiss(animated: false)
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    @objc func tappedNextBottomButton() {
        if (addLinkView.linkEmbedTextField.text?.count ?? 0) < 1 {
            addLinkView.emptyError()
        } else {
            let selectClipViewController = SelectClipViewController()
            selectClipViewController.delegate = self
            self.navigationController?.pushViewController(selectClipViewController, animated: true)
        }
    }
    
}

extension AddLinkViewController: SaveLinkButtonDelegate {
    func saveLinkButtonTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }       
        tabBarController?.showToastMessage(width: 169, status: .check, message: "링크 저장 완료!")
    }
    
    func cancleLinkButtonTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
}

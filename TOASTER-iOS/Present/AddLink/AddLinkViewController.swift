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
        print("안ㄴ123123")
        addLinkView.linkEmbedTextField.placeholder = "복사한 링크를 붙여 넣어 주세요"
        addLinkView.nextTopButton.isEnabled = false
        addLinkView.nextTopButton.backgroundColor = .gray200
        addLinkView.nextBottomButton.isEnabled = false
        addLinkView.nextBottomButton.backgroundColor = .gray200
        addLi
    }
    
    func closeButtonTapped() {
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
        closeButtonTapped()
        tabBarController?.showToastMessage(width: 169, status: .check, message: "링크 저장 완료!")
    }
    
    func cancleLinkButtonTapped() {
        closeButtonTapped()
    }
}

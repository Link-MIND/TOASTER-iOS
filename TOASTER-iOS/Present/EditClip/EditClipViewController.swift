//
//  EditClipViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class EditClipViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let editClipNoticeView = EditClipNoticeView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
}

// MARK: - Networks

extension EditClipViewController {
    func fetchMain() {
        
    }
}

// MARK: - Private Extensions

private extension EditClipViewController {
    func setupStyle() {
        
    }
    
    func setupHierarchy() {
        view.addSubviews(editClipNoticeView)
    }
    
    func setupLayout() {
        editClipNoticeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
    }
    
    func setupDelegate() {
        
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true, hasRightButton: false, mainTitle: StringOrImageType.string("CLIP 편집"), rightButton: StringOrImageType.string(""), rightButtonAction: {})
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
}


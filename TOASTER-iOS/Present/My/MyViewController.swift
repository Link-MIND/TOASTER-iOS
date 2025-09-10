//
//  MyViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 8/10/25.
//

import UIKit

import SnapKit

final class MyViewController: UIViewController {
    
    // MARK: - Properties
    
    var onSettingSelected: (() -> Void)?
    
    // MARK: - UI Properties
        
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
    }
    
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

extension MyViewController {
    func fetchMain() {
        
    }
}

// MARK: - Private Extensions

private extension MyViewController {
    func setupStyle() {

    }
    
    func setupHierarchy() {
        
    }
    
    func setupLayout() {
        
    }
    
    func setupDelegate() {
        
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(
            hasBackButton: false,
            hasRightButton: true,
            mainTitle: StringOrImageType.string(StringLiterals.Tabbar.my),
            rightButton: StringOrImageType.image(.icSettings24),
            rightButtonAction: onSettingSelected
        )
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
}

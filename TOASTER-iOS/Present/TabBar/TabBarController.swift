//
//  TabBarController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

// MARK: - Tab Bar

final class TabBarController: UITabBarController {
    
    var customTabBar = CustomTabBar()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValue(customTabBar, forKey: "tabBar")
        setupStyle()
        addTabBarController()
        setupNavigation()
    }
}

// MARK: - Private Extensions

private extension TabBarController {
    func setupStyle() {
        self.view.backgroundColor = .toasterBackground
        tabBar.backgroundColor = .toasterWhite
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
    }
    
    func addTabBarController() {
        var tabNavigationControllers = [UINavigationController]()
        
        for item in TabBarItem.allCases {
            let tabNavController = createTabNavigationController(
                title: item.itemTitle ?? "",
                image: item.normalItem ?? UIImage(),
                selectedImage: item.selectedItem ?? UIImage(),
                viewController: item.targetViewController,
                inset: item == TabBarItem.plus ? UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0) : nil
            )
            tabNavigationControllers.append(tabNavController)
        }
        setViewControllers(tabNavigationControllers, animated: true)
    }
    
    func createTabNavigationController(title: String, image: UIImage, selectedImage: UIImage, viewController: UIViewController?, inset: UIEdgeInsets? ) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        var tabbarItem = UITabBarItem(
            title: title,
            image: image.withRenderingMode(.alwaysOriginal),
            selectedImage: selectedImage.withRenderingMode(.alwaysOriginal)
        )
        
        if let inset {
            tabbarItem.imageInsets = inset
        }
        
        // title이 선택되지 않았을 때 폰트, 색상 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.suitBold(size: 12),
            .foregroundColor: UIColor.gray150
        ]
        
        // title이 선택되었을 때 폰트, 색상 설정
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.suitBold(size: 12),
            .foregroundColor: UIColor.black900
        ]
        
        tabbarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        tabNavigationController.tabBarItem = tabbarItem
        if let viewController = viewController {
            tabNavigationController.viewControllers = [viewController]
        }
        return tabNavigationController
    }
}

// Custom Tab Bar
final class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 60 + safeAreaInsets.bottom
        return size
    }
}

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
    }
}

// MARK: - Private Extensions

private extension TabBarController {
    func setupStyle() {
        delegate = self
        view.backgroundColor = .toasterBackground
        tabBar.backgroundColor = .toasterWhite
        tabBar.unselectedItemTintColor = .gray150
        tabBar.tintColor = .black950
    }
    
    func addTabBarController() {
        var viewControllers = [UIViewController]()
        for item in TabBarItem.allCases {
            let currentViewController = createViewController(
                title: item.itemTitle ?? "",
                image: item.normalItem ?? UIImage(),
                selectedImage: item.selectedItem ?? UIImage(),
                viewController: item.targetViewController,
                inset: item == TabBarItem.plus ? UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0) : nil
            )
            viewControllers.append(currentViewController)
        }
        setViewControllers(viewControllers, animated: false)
    }
    
    func createViewController(title: String,
                              image: UIImage,
                              selectedImage: UIImage,
                              viewController: UIViewController,
                              inset: UIEdgeInsets? ) -> UIViewController {
        let currentViewController = viewController
        let tabbarItem = UITabBarItem(
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
        
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        tabbarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabbarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        currentViewController.tabBarItem = tabbarItem
        
        return currentViewController
    }
}

// Custom Tab Bar
final class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height += 11
        return size
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == viewControllers?[2] {
            let addLinkViewController = AddLinkViewController()
            addLinkViewController.setupDelegate(forDelegate: self)
            navigationController?.pushViewController(addLinkViewController, animated: false)
            return false
        }
        return true
    }
}

extension TabBarController: AddLinkViewControllerPopDelegate {
    func popToHomeViewController() {
        selectedIndex = 0
    }
}

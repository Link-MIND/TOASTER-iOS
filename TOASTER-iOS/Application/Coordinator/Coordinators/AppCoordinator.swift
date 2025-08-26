//
//  AppCoordinator.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/7/25.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private let router: RouterProtocol
    private let viewControllerFactory: ViewControllerFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private var isLoggedIn: Bool
    
    init(
        router: RouterProtocol,
        viewControllerFactory: ViewControllerFactoryProtocol,
        coordinatorFactory: CoordinatorFactoryProtocol,
        isLoggedIn: Bool
    ) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
        self.coordinatorFactory = coordinatorFactory
        self.isLoggedIn = isLoggedIn
    }
    
    override func start() {
        if isLoggedIn {
            setTabBarRootVC()
        } else {
            setLoginRootVC()
        }
    }
    
    func handlePasteboardURL() {
        if let pasteboardUrl = UIPasteboard.general.url, isLoggedIn {
            let vc = viewControllerFactory.makeAddLinkVC(isNavigationBarHidden: false)
            vc.embedURL(url: pasteboardUrl.absoluteString)
            vc.onPopToRoot = { [weak self] in
                self?.router.popToRoot(animated: false)
            }
            router.push(vc, animated: true)
        }
    }
}

private extension AppCoordinator {
    func setLoginRootVC() {
        let coordinator = coordinatorFactory.makeLoginCoordinator(
            router: router,
            viewControllerFactory: viewControllerFactory,
            coordinatorFactory: coordinatorFactory
        )
        coordinator.onFinish = { [weak self, weak coordinator] in
            self?.isLoggedIn = true
            self?.removeDependency(coordinator)
            self?.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
    
    func setTabBarRootVC() {
        let coordinator = coordinatorFactory.makeTabBarCoordinator(
            router: router,
            viewControllerFactory: viewControllerFactory,
            coordinatorFactory: coordinatorFactory
        )
        coordinator.onFinish = { [weak self, weak coordinator] in
            self?.isLoggedIn = false
            self?.removeDependency(coordinator)
            self?.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
}

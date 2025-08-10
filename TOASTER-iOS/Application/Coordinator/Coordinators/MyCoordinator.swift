//
//  MyCoordinator.swift
//  TOASTER-iOS
//
//  Created by 민 on 8/10/25.
//

import Foundation

final class MyCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    var onFinish: (() -> Void)?
    
    private let router: RouterProtocol
    private let viewControllerFactory: ViewControllerFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    init(
        router: RouterProtocol,
        viewControllerFactory: ViewControllerFactoryProtocol,
        coordinatorFactory: CoordinatorFactoryProtocol
    ) {
        self.router = router
        self.viewControllerFactory = viewControllerFactory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        showMyVC()
    }
}

private extension MyCoordinator {
    func showMyVC() {
        let vc = viewControllerFactory.makeMyVC()
        vc.onSettingSelected = { [weak self] in
            self?.showSettingVC()
        }
        router.setRoot(vc, animated: false)
    }
    
    func showSettingVC() {
        let vc = viewControllerFactory.makeSettingVC()
        vc.onChangeRoot = { [weak self] in
            self?.router.dismiss()  // 로그아웃 완료 Alert dismiss
            self?.onFinish?()
        }
        router.push(vc, animated: true, hideBottomBarWhenPushed: true)
    }
}

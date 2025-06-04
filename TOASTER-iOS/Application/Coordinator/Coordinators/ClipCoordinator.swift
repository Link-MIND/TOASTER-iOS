//
//  ClipCoordinator.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/7/25.
//

import Foundation

final class ClipCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
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
        showClipVC()
    }
}

private extension ClipCoordinator {
    func showClipVC() {
        let vc = viewControllerFactory.makeClipVC()
        vc.onEditClipSelected = { [weak self] clipList in
            self?.showEditClipVC(clipList: clipList)
        }
        vc.onClipItemSelected = { [weak self] clipId, clipName in
            self?.showDetailClipVC(id: clipId, name: clipName)
        }
        vc.onRootDeleteToken = { [weak self] in
            _ = KeyChainService.deleteTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
            self?.onFinish?()
        }
        router.setRoot(vc, animated: false)
    }
    
    func showEditClipVC(clipList: ClipModel) {
        let vc = viewControllerFactory.makeEditClipVC()
        vc.setupDataBind(clipModel: clipList)
        vc.onRootDeleteToken = { [weak self] in
            _ = KeyChainService.deleteTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
            self?.onFinish?()
        }
        router.push(vc, animated: false, hideBottomBarWhenPushed: true)
    }
    
    func showDetailClipVC(id: Int, name: String) {
        let vc = viewControllerFactory.makeDetailClipVC()
        vc.setupCategory(id: id, name: name)
        vc.onLinkSelected = { [weak self] linkURL, isRead, id in
            self?.showLinkWebVC(linkURL: linkURL, isRead: isRead, id: id)
        }
        vc.onRootDeleteToken = { [weak self] in
            _ = KeyChainService.deleteTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
            self?.onFinish?()
        }
        router.push(vc, animated: true, hideBottomBarWhenPushed: true)
    }
    
    func showLinkWebVC(linkURL: String, isRead: Bool, id: Int) {
        let vc = viewControllerFactory.makeLinkWebVC()
        vc.setupDataBind(linkURL: linkURL, isRead: isRead, id: id)
        vc.onBack = { [weak self] in
            self?.router.pop(animated: true)
        }
        vc.onRootDeleteToken = { [weak self] in
            _ = KeyChainService.deleteTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
            self?.onFinish?()
        }
        router.push(vc, animated: true, hideBottomBarWhenPushed: true)
    }
}

//
//  ToasterNavigationController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/4/24.
//

import UIKit

final class ToasterNavigationController: UINavigationController {

    // MARK: - Properties

    private let navigationHeight: CGFloat = 64
    
    // MARK: - UI Properties

    private let safeAreaView: UIView = UIView()
    private let customNavigationBar: UIView = UINavigationBar()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupHierarchy()
        setupLayout()
        hideDefaultNavigationBar()
        setupSafeArea(navigationBarHidden: isNavigationBarHidden)
    }
    
    override var isNavigationBarHidden: Bool {
        didSet {
            hideDefaultNavigationBar()
            safeAreaView.isHidden = isNavigationBarHidden
            customNavigationBar.isHidden = isNavigationBarHidden
            setupSafeArea(navigationBarHidden: isNavigationBarHidden)
        }
    }
}

// MARK: - Private Extensions

private extension ToasterNavigationController {
    
    func setupStyle() {
        customNavigationBar.do {
            $0.backgroundColor = .toasterWhite
        }
        
        safeAreaView.do {
            $0.backgroundColor = customNavigationBar.backgroundColor
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(safeAreaView, customNavigationBar)
    }
    
    func setupLayout() {
        customNavigationBar.snp.makeConstraints {
            $0.height.equalTo(navigationHeight)
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
        
        safeAreaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    /// navigationBar가 hidden 상태인지 아닌지에 따라 view의 safeArea를 정해주는 함수
    func setupSafeArea(navigationBarHidden: Bool) {
        if navigationBarHidden {
            additionalSafeAreaInsets = UIEdgeInsets(top:0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        } else {
            additionalSafeAreaInsets = UIEdgeInsets(top: navigationHeight,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        }
    }
    
    /// DetaultNavigationBar를 hidden 시켜주는 함수
    func hideDefaultNavigationBar() {
        navigationBar.isHidden = true
    }
}

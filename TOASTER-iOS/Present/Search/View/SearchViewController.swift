//
//  SearchViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let navigationBar: UIView = UIView()
    private let searchTextField: UITextField = UITextField()
    private let backButton: UIButton = UIButton()
    private let rightButton: UIButton = UIButton()
        
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar()
    }
}

private extension SearchViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        
        navigationBar.do {
            $0.backgroundColor = .toasterBackground
        }
        
        backButton.do {
            $0.setImage(ImageLiterals.Common.arrowLeft, for: .normal)
        }
        
        rightButton.do {
            $0.setImage(ImageLiterals.Search.searchIcon, for: .normal)
        }
        
        searchTextField.do {
            $0.makeRounded(radius: 12)
            $0.addPadding(left: 12, right: 44)
            $0.backgroundColor = .gray50
            $0.placeholder = "검색어를 입력해주세요"
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationBar)
        navigationBar.addSubviews(backButton, searchTextField)
        searchTextField.addSubview(rightButton)
    }
    
    func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.height.equalTo(64)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        rightButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

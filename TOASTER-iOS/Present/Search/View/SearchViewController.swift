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
    
    private var isSearchButtonHidden: Bool = false {
        didSet {
            searchButton.isHidden = isSearchButtonHidden
            clearButton.isHidden = !isSearchButtonHidden
        }
    }
    
    // MARK: - UI Properties
    
    private let navigationBar: UIView = UIView()
    private let searchTextField: UITextField = UITextField()
    private let backButton: UIButton = UIButton()
    private let searchButton: UIButton = UIButton()
    private let clearButton: UIButton = UIButton()
    
    private let emptyView: SearchEmptyResultView = SearchEmptyResultView()
        
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
        setupEmptyView(isHidden: true)
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
        
        searchButton.do {
            $0.setImage(ImageLiterals.Search.searchIcon, for: .normal)
            $0.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        }
        
        clearButton.do {
            $0.setImage(ImageLiterals.Search.searchCancle, for: .normal)
            $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
            $0.isHidden = true
        }
        
        searchTextField.do {
            $0.makeRounded(radius: 12)
            $0.addPadding(left: 12, right: 44)
            $0.backgroundColor = .gray50
            $0.placeholder = "검색어를 입력해주세요"
            $0.delegate = self
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationBar, emptyView)
        navigationBar.addSubviews(backButton, searchTextField)
        searchTextField.addSubviews(searchButton, clearButton)
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
        
        [searchButton, clearButton].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(20)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(12)
            }
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        emptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom).offset(view.convertByHeightRatio(176))
        }
    }
    
    func setupEmptyView(isHidden: Bool) {
        emptyView.isHidden = isHidden
    }
    
    func fetchSearchResult() {
        isSearchButtonHidden = true
        view.endEditing(true)
        
        // TODO: - API 호출

    }
    
    @objc func searchButtonTapped() {
        fetchSearchResult()
    }
    
    @objc func clearButtonTapped() {
        searchTextField.text = nil
        isSearchButtonHidden = false
        searchTextField.becomeFirstResponder()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchSearchResult()
        return true
    }
}

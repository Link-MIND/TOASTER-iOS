//
//  SearchViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import Combine
import UIKit

import SnapKit
import Then

final class SearchViewController: UIViewController {
    
    // MARK: - View Controllable
    
    var onBack: (() -> Void)?
    var onLinkItemSelected: ((String, Bool, Int) -> Void)?
    var onClipItemSelected: ((Int, String) -> Void)?
    
    // MARK: - Data Stream

    private let viewModel: SearchViewModel!
    private let cancelBag = CancelBag()
    
    private let searchSubject = PassthroughSubject<String, Never>()
    lazy var clearButtonTapped = clearButton.publisher(for: .touchUpInside).mapVoid()
    lazy var textFieldBeginEditing = NotificationCenter.default.publisher(
        for: UITextField.textDidChangeNotification,
        object: self.searchTextField
    )

    // MARK: - UI Properties
    
    private let navigationBar: UIView = UIView()
    private let searchTextField: UITextField = UITextField()
    private let backButton: UIButton = UIButton()
    private let searchButton: UIButton = UIButton()
    private let clearButton: UIButton = UIButton()
    
    private let emptyView: SearchEmptyResultView = SearchEmptyResultView()
    private let searchResultCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Life Cycle
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModels()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
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

// MARK: - Private Extensions

private extension SearchViewController {
    func bindViewModels() {
        let input = SearchViewModel.Input(
            searchButtonTapped: searchSubject.asDriver(),
            clearButtonTapped: clearButtonTapped.asDriver(),
            textFieldBeginEdited: textFieldBeginEditing.mapVoid().asDriver()
        )
        
        let output = viewModel.transform(input, cancelBag: cancelBag)
        
        output.loadToSearchResults
            .sink { [weak self] isEmpty in
                guard let self else { return }
                emptyView.isHidden = !isEmpty
                searchResultCollectionView.isHidden = isEmpty
                searchResultCollectionView.reloadData()
                searchResultCollectionView.setContentOffset(CGPoint.zero, animated: true)
            }.store(in: cancelBag)
        
        output.startSearching
            .sink { [weak self] in
                guard let self else { return }
                searchTextField.text = nil
                searchTextField.becomeFirstResponder()
            }.store(in: cancelBag)
        
        output.isSearching
            .sink { [weak self] isSearching in
                guard let self else { return }
                searchButton.isHidden = !isSearching
                clearButton.isHidden = isSearching
            }.store(in: cancelBag)
        
        output.navigateToLogin
            .sink {
                NotificationCenter.default.post(name: .refreshTokenExpired, object: nil)
            }.store(in: cancelBag)
    }
    
    func setupStyle() {
        hideKeyboard()
        
        view.backgroundColor = .toasterBackground
        
        navigationBar.do {
            $0.backgroundColor = .toasterBackground
        }
        
        backButton.do {
            $0.setImage(.icArrowLeft24, for: .normal)
            $0.addAction(
                UIAction { _ in
                    self.onBack?()
                }, for: .touchUpInside
            )
        }
        
        searchButton.do {
            $0.setImage(.icSearch20, for: .normal)
            $0.addAction(
                UIAction { _ in
                    self.performSearch()
                }, for: .touchUpInside
            )
        }
        
        clearButton.do {
            $0.setImage(.icSearchCancle, for: .normal)
            $0.isHidden = true
        }
        
        searchTextField.do {
            $0.makeRounded(radius: 12)
            $0.addPadding(left: 12, right: 44)
            $0.backgroundColor = .gray50
            $0.placeholder = StringLiterals.Placeholder.search
            $0.becomeFirstResponder()
        }
        
        emptyView.do {
            $0.isHidden = true
        }
        
        searchResultCollectionView.do {
            $0.register(ClipListCollectionViewCell.self, forCellWithReuseIdentifier: ClipListCollectionViewCell.className)
            $0.register(DetailClipListCollectionViewCell.self, forCellWithReuseIdentifier: DetailClipListCollectionViewCell.className)
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationBar, emptyView, searchResultCollectionView)
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
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupDelegate() {
        searchTextField.delegate = self
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    func performSearch() {
        let query = searchTextField.text ?? ""
        searchSubject.send(query)
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let data = viewModel.searchResults.detailClipList[indexPath.item]
            onLinkItemSelected?(data.link, data.isRead, data.iD)
        case 1:
            let data = viewModel.searchResults.clipList[indexPath.item]
            onClipItemSelected?(data.iD, data.title)
        default: break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.searchResults.detailClipList.count
        case 1:
            return viewModel.searchResults.clipList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailClipListCollectionViewCell.className, for: indexPath) as? DetailClipListCollectionViewCell,
                  let text = searchTextField.text else { return UICollectionViewCell() }
            cell.configureCell(forModel: viewModel.searchResults.detailClipList[indexPath.item],
                               forText: text)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipListCollectionViewCell.className, for: indexPath) as? ClipListCollectionViewCell,
                  let text = searchTextField.text
            else { return UICollectionViewCell() }
            cell.configureCell(forModel: viewModel.searchResults.clipList[indexPath.item], forText: text)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.convertByWidthRatio(335), height: 98)
        case 1:
            return CGSize(width: collectionView.convertByWidthRatio(335), height: 52)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

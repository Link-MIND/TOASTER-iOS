//
//  SelectClipBottomSheetView.swift
//  ToasterShareExtension
//
//  Created by ParkJunHyuk on 3/20/24.
//

import UIKit

import SnapKit
import Then

protocol SelectClipBottomSheetViewDelegate: AnyObject {
    func saveLinkTapped(categoryID: Int)
}

final class SelectClipBottomSheetView: UIView {

    // MARK: - Properties
    
    private let viewModel = RemindSelectClipViewModel()
    private var categoryID: Int?
    private var selectedClip: RemindClipModel? {
        didSet {
            nextButton.backgroundColor = .toasterBlack
        }
    }
    
    weak var delegate: SelectClipBottomSheetViewDelegate?
    
    // MARK: - UI Components
    
    private lazy var clipSelectCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let nextButton: UIButton = UIButton()

    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

extension SelectClipBottomSheetView {
    func setupStyle() {
        clipSelectCollectionView.do {
            $0.backgroundColor = .toasterBackground
            $0.register(RemindSelectClipCollectionViewCell.self, forCellWithReuseIdentifier: RemindSelectClipCollectionViewCell.className)
        }
        
        nextButton.do {
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .gray200
            $0.setTitle(StringLiterals.Button.next, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        addSubviews(clipSelectCollectionView, nextButton)
    }
    
    func setupLayout() {
        clipSelectCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.bottom.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setupDelegate() {
        clipSelectCollectionView.delegate = self
        clipSelectCollectionView.dataSource = self
    }
    
    func setupViewModel() {
        viewModel.setupDataChangeAction {
            self.clipSelectCollectionView.reloadData()
        }
    }
    
    @objc func nextButtonTapped() {
        delegate?.saveLinkTapped(categoryID: categoryID ?? 0)
    }
}

// MARK: - UICollectionViewDelegate

extension SelectClipBottomSheetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedClip = viewModel.clipData[indexPath.item]
        categoryID = viewModel.clipData[indexPath.item].id
    }
}

// MARK: - UICollectionViewDataSource

extension SelectClipBottomSheetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.clipData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemindSelectClipCollectionViewCell.className, for: indexPath) as? RemindSelectClipCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(forModel: viewModel.clipData[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectClipBottomSheetView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: convertByWidthRatio(335), height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//
//  ClipViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class ClipViewController: UIViewController {
    
    // MARK: - Properties
        
    // MARK: - UI Properties
    
    private let clipEmptyView = ClipEmptyView()
    private let addClipBottomSheetView = AddClipBottomSheetView()
    private let clipListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .toasterBackground
    }
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupRegisterCell()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupEmptyView()
    }
}

// MARK: - Networks

extension ClipViewController {
    func fetchMain() {
        
    }
}

// MARK: - Private Extensions

private extension ClipViewController {
    func setupStyle() {
        hideNavigationBar()
    }
    
    func setupHierarchy() {
        view.addSubviews(clipListCollectionView, clipEmptyView)
    }
    
    func setupLayout() {
        clipListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        clipEmptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupRegisterCell() {
        clipListCollectionView.register(ClipListCollectionViewCell.self, forCellWithReuseIdentifier: ClipListCollectionViewCell.identifier)
        clipListCollectionView.register(ClipCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.identifier)
    }
    
    func setupDelegate() {
        clipListCollectionView.delegate = self
        clipListCollectionView.dataSource = self
        addClipBottomSheetView.addClipBottomSheetDelegate = self
    }
    
    func setupEmptyView() {
        if dummyClipList.count > 0 {
            clipEmptyView.isHidden = true
        } else {
            clipEmptyView.isHidden = false
        }
    }
}

// MARK: - CollectionView Delegate

extension ClipViewController: UICollectionViewDelegate {}

// MARK: - CollectionView DataSource

extension ClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyClipList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipListCollectionViewCell.identifier, for: indexPath) as? ClipListCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.configureCell(forModel: ClipListModel(categoryID: 0, categoryTitle: "전체클립", toastNum: 100))
        } else {
            cell.configureCell(forModel: dummyClipList[indexPath.row-1])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.identifier, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
            return headerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - CollectionView Delegate Flow Layout

extension ClipViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: collectionView.convertByHeightRatio(52))
    }
    
    // ContentInset: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // minimumLineSpacing: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // referenceSizeForHeaderInSection: 각 섹션의 헤더 뷰 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
}

extension ClipViewController: AddClipBottomSheetDelegate {
    func addClipButtonTapped() {
        
    }
}

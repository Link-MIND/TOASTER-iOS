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
        
    // MARK: - UI Properties
    
    private let clipEmptyView = ClipEmptyView()
    private let addClipBottomSheetView = AddClipBottomSheetView()
    private let clipListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        setupNavigationBar()
    }
}

// MARK: - Extensions

extension ClipViewController {
    func showBottom() {
        let view = AddClipBottomSheetView()
        let exampleBottom = ToasterBottomSheetViewController(bottomType: .white, bottomTitle: "클립 추가", height: 500, insertView: view)
        exampleBottom.modalPresentationStyle = .overFullScreen  // 애니메이션을 위해 필수 지정
        self.present(exampleBottom, animated: false)  // 애니메이션을 위해 필수 지정
    }
}

// MARK: - Private Extensions

private extension ClipViewController {
    func setupStyle() {
        clipListCollectionView.backgroundColor = .toasterBackground
    }
    
    func setupHierarchy() {
        view.addSubviews(clipListCollectionView, clipEmptyView)
    }
    
    func setupLayout() {
        clipListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        clipEmptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(self.view.convertByHeightRatio(280))
        }
    }
    
    func setupRegisterCell() {
        clipListCollectionView.register(ClipListCollectionViewCell.self, forCellWithReuseIdentifier: ClipListCollectionViewCell.className)
        clipListCollectionView.register(ClipCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className)
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
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string(StringLiterals.Tabbar.Title.clip),
                                                                rightButton: StringOrImageType.string(StringLiterals.Clip.Title.edit),
                                                                rightButtonAction: editButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func editButtonTapped() {
        // 편집 버튼 클릭 시 로직
    }
}

// MARK: - CollectionView Delegate

extension ClipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = DetailClipViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CollectionView DataSource

extension ClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyClipList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipListCollectionViewCell.className, for: indexPath) as? ClipListCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.configureCell(forModel: ClipListModel(categoryID: 0, categoryTitle: "전체클립", toastNum: 100))
        } else {
            cell.configureCell(forModel: dummyClipList[indexPath.row-1])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
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

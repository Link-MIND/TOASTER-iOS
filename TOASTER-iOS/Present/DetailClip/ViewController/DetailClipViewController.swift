//
//  DetailClipViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit

final class DetailClipViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let detailClipSegmentedControlView = DetailClipSegmentedControlView()
    private let detailClipEmptyView = DetailClipEmptyView()
    private let detailClipListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let deleteLinkBottomSheetView = DeleteLinkBottomSheetView()
    private lazy var bottom = ToasterBottomSheetViewController(bottomType: .gray, bottomTitle: "수정하기", height: 172, insertView: deleteLinkBottomSheetView)
    
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

extension DetailClipViewController {
    func fetchMain() {
        
    }
}

// MARK: - Private Extensions

private extension DetailClipViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        detailClipListCollectionView.backgroundColor = .toasterBackground
    }
    
    func setupHierarchy() {
        view.addSubviews(detailClipSegmentedControlView, detailClipListCollectionView, detailClipEmptyView)
    }
    
    func setupLayout() {
        detailClipSegmentedControlView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }
        
        detailClipListCollectionView.snp.makeConstraints {
            $0.top.equalTo(detailClipSegmentedControlView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        detailClipEmptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupRegisterCell() {
        detailClipListCollectionView.register(DetailClipListCollectionViewCell.self, forCellWithReuseIdentifier: DetailClipListCollectionViewCell.className)
        detailClipListCollectionView.register(ClipCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className)
    }
    
    func setupDelegate() {
        detailClipListCollectionView.delegate = self
        detailClipListCollectionView.dataSource = self
    }
    
    func setupEmptyView() {
        if dummyDetailClipList.count > 0 {
            detailClipEmptyView.isHidden = true
        } else {
            detailClipEmptyView.isHidden = false
        }
    }
}

// MARK: - CollectionView DataSource

extension DetailClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyDetailClipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailClipListCollectionViewCell.className, for: indexPath) as? DetailClipListCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(forModel: dummyDetailClipList[indexPath.row].toastListDto[0])
        cell.detailClipListCollectionViewCellButtonAction = {
            self.bottom.modalPresentationStyle = .overFullScreen
            self.present(self.bottom, animated: false)
        }
        deleteLinkBottomSheetView.deleteLinkBottomSheetViewButtonAction = {
            self.bottom.hideBottomSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showToastMessage(width: 152, status: .check, message: "링크 삭제 완료")
            }        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
        headerView.isaddClipButtonHidden()
        headerView.setupDataBind(count: dummyDetailClipList.count)
        return headerView
    }
}

// MARK: - CollectionView Delegate

extension DetailClipViewController: UICollectionViewDelegate {
    
}

// MARK: - CollectionView Delegate Flow Layout
extension DetailClipViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: collectionView.convertByHeightRatio(98))
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
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

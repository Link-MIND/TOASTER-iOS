//
//  DetailClipViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit

final class DetailClipViewController: UIViewController {
    
    // MARK: - Properties
    
    private var categoryID: Int = 0
    private var categoryName: String = ""
    private var clipCount: Int = 0
    private var toastList: GetDetailCategoryResponseDTO? {
        didSet {
            detailClipListCollectionView.reloadData()
            setupEmptyView()
        }
    }
    
    // MARK: - UI Properties
    
    private let detailClipSegmentedControlView = DetailClipSegmentedControlView()
    private let detailClipEmptyView = DetailClipEmptyView()
    private let detailClipListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let deleteLinkBottomSheetView = DeleteLinkBottomSheetView()
    private lazy var bottom = ToasterBottomSheetViewController(bottomType: .gray, bottomTitle: StringLiterals.BottomSheet.Title.modified, height: 72, insertView: deleteLinkBottomSheetView)
    
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
        
        setupNavigationBar()
    }
}

// MARK: - Extensions

extension DetailClipViewController {
    func setupCategory(id: Int, name: String) {
        categoryID = id
        categoryName = name
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
            $0.height.equalTo(60)
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
        detailClipSegmentedControlView.detailClipSegmentedDelegate = self
    }
    
    func setupEmptyView() {
        if let data = toastList?.data {
            detailClipEmptyView.isHidden = data.allToastNum > 0 ? true : false
        }
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true,
                                                                hasRightButton: false,
                                                                mainTitle: StringOrImageType.string(categoryName),
                                                                rightButton: StringOrImageType.string("어쩌구"), rightButtonAction: {})
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
}

// MARK: - CollectionView DataSource

extension DetailClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toastList?.data.toastListDto.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailClipListCollectionViewCell.className, for: indexPath) as? DetailClipListCollectionViewCell else { return UICollectionViewCell() }
        
        if let data = toastList?.data {
            cell.configureCell(forModel: data, index: indexPath.row)
        }
        cell.detailClipListCollectionViewCellButtonAction = {
            self.bottom.modalPresentationStyle = .overFullScreen
            self.present(self.bottom, animated: false)
        }
        deleteLinkBottomSheetView.setupDeleteLinkBottomSheetButtonAction {
            self.bottom.hideBottomSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showToastMessage(width: 152, status: .check, message: StringLiterals.Toast.Message.completeDeleteLink)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
        headerView.isDetailClipView(isHidden: true)
        headerView.setupDataBind(count: clipCount)
        return headerView
    }
}

// MARK: - CollectionView Delegate

extension DetailClipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = LinkWebViewController()
        nextVC.hidesBottomBarWhenPushed = true
        if let data = toastList?.data {
            nextVC.setupDataBind(linkURL: data.toastListDto[indexPath.row].linkUrl,
                                 isRead: data.toastListDto[indexPath.row].isRead)
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CollectionView Delegate Flow Layout
extension DetailClipViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: 98)
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
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}

// MARK: - DetailClipSegmented Delegate

extension DetailClipViewController: DetailClipSegmentedDelegate {
    func setupAllLink() {
        if categoryID == 0 {
            getDetailAllCategoryAPI(filter: .all)
        } else {
            getDetailCategoryAPI(categoryID: categoryID, filter: .all)
        }
    }
    
    func setupReadLink() {
        if categoryID == 0 {
            getDetailAllCategoryAPI(filter: .read)
        } else {
            getDetailCategoryAPI(categoryID: categoryID, filter: .read)
        }
    }
    
    func setupNotReadLink() {
        if categoryID == 0 {
            getDetailAllCategoryAPI(filter: .unread)
        } else {
            getDetailCategoryAPI(categoryID: categoryID, filter: .unread)
        }
    }
}

// MARK: - Network

extension DetailClipViewController {
    func getDetailAllCategoryAPI(filter: DetailCategoryFilter) {
        NetworkService.shared.clipService.getDetailAllCategory(filter: filter) { result in
            switch result {
            case .success(let response):
                self.toastList = response
                self.clipCount = response?.data.toastListDto.count ?? 0
            default: return
            }
        }
    }
    
    func getDetailCategoryAPI(categoryID: Int, filter: DetailCategoryFilter) {
        NetworkService.shared.clipService.getDetailCategory(categoryID: categoryID, filter: filter) { result in
            switch result {
            case .success(let response):
                self.toastList = response
            default: return
            }
        }
    }
}

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
    
    private let viewModel = DetailClipViewModel()
    private let detailClipSegmentedControlView = DetailClipSegmentedControlView()
    private let detailClipEmptyView = DetailClipEmptyView()
    private let detailClipListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let deleteLinkBottomSheetView = DeleteLinkBottomSheetView()
    private lazy var bottom = ToasterBottomSheetViewController(bottomType: .gray, 
                                                               bottomTitle: "수정하기",
                                                               height: 126,
                                                               insertView: deleteLinkBottomSheetView)
    
    private let editLinkBottomSheetView = EditLinkBottomSheetView()
    private lazy var editLinkBottom = ToasterBottomSheetViewController(bottomType: .white,
                                                                       bottomTitle: "링크 제목 편집",
                                                                       height: 198,
                                                                       insertView: editLinkBottomSheetView)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupRegisterCell()
        setupDelegate()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        setupAllLink()
    }
}

// MARK: - Extensions

extension DetailClipViewController {
    func setupCategory(id: Int, name: String) {
        viewModel.categoryId = id
        viewModel.categoryName = name
    }
}

// MARK: - Private Extensions

private extension DetailClipViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        detailClipListCollectionView.backgroundColor = .toasterBackground
        detailClipEmptyView.isHidden = false
        editLinkBottomSheetView.editLinkBottomSheetViewDelegate = self
        
    }
    
    func setupHierarchy() {
        view.addSubviews(detailClipSegmentedControlView, 
                         detailClipListCollectionView,
                         detailClipEmptyView)
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
    
    func setupViewModel() {
        viewModel.setupDataChangeAction(changeAction: reloadCollectionView,
                                        forUnAuthorizedAction: unAuthorizedAction,
                                        editNameAction: editLinkTitleAction)
    }
    
    func reloadCollectionView(isHidden: Bool) {
        detailClipListCollectionView.reloadData()
        detailClipEmptyView.isHidden = isHidden
    }
    
    func unAuthorizedAction() {
        changeViewController(viewController: LoginViewController())
    }
    
    func editLinkTitleAction() {
        showToastMessage(width: 157, status: .check, message: StringLiterals.ToastMessage.completeEditClip)
        editLinkBottomSheetView.resetTextField()
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true,
                                                                hasRightButton: false,
                                                                mainTitle: StringOrImageType.string(viewModel.categoryName),
                                                                rightButton: StringOrImageType.string("어쩌구"), rightButtonAction: {})
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
}

// MARK: - CollectionView DataSource

extension DetailClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.toastList.toastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailClipListCollectionViewCell.className, for: indexPath) as? DetailClipListCollectionViewCell else { return UICollectionViewCell() }
        cell.detailClipListCollectionViewCellDelegate = self
        if viewModel.categoryId == 0 {
            cell.configureCell(forModel: viewModel.toastList, index: indexPath.item, isClipHidden: false)
        } else {
            cell.configureCell(forModel: viewModel.toastList, index: indexPath.item, isClipHidden: true)
        }
        deleteLinkBottomSheetView.setupDeleteLinkBottomSheetButtonAction {
            self.viewModel.deleteLinkAPI(toastId: self.viewModel.toastId)
            self.bottom.hideBottomSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showToastMessage(width: 152, status: .check, message: StringLiterals.ToastMessage.completeDeleteLink)
            }
        }
        deleteLinkBottomSheetView.setupEditLinkTitleBottomSheetButtonAction {
            self.viewModel.getDetailCategoryAPI(categoryID: self.viewModel.categoryId,
                                                filter: DetailCategoryFilter.all)
            self.bottom.hideBottomSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.editLinkBottom.modalPresentationStyle = .overFullScreen
                self.present(self.editLinkBottom, animated: true)
                self.editLinkBottomSheetView.setupTextField(message: self.viewModel.linkTitle)
            }
        }
        editLinkBottomSheetView.setupConfirmBottomSheetButtonAction {
            self.viewModel.getDetailCategoryAPI(categoryID: self.viewModel.categoryId,
                                                filter: DetailCategoryFilter.all)
            self.bottom.hideBottomSheet()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showToastMessage(width: 152, status: .check, message: StringLiterals.ToastMessage.completeEditTitle)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
        headerView.isDetailClipView(isHidden: true)
        if viewModel.segmentIndex == 0 {
            headerView.setupDataBind(title: "전체",
                                     count: viewModel.toastList.toastList.count)
        } else if viewModel.segmentIndex == 1 {
            headerView.setupDataBind(title: "열람",
                                     count: viewModel.toastList.toastList.count)
        } else {
            headerView.setupDataBind(title: "미열람",
                                     count: viewModel.toastList.toastList.count)
        }
        return headerView
    }
}

// MARK: - CollectionView Delegate

extension DetailClipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = LinkWebViewController()
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.setupDataBind(linkURL: viewModel.toastList.toastList[indexPath.item].url,
                             isRead: viewModel.toastList.toastList[indexPath.item].isRead,
                             id: viewModel.toastList.toastList[indexPath.item].id)
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
        viewModel.segmentIndex = 0
        if viewModel.categoryId == 0 {
            viewModel.getDetailAllCategoryAPI(filter: .all)
        } else {
            viewModel.getDetailCategoryAPI(categoryID: viewModel.categoryId, filter: .all)
        }
    }
    
    func setupReadLink() {
        viewModel.segmentIndex = 1
        if viewModel.categoryId == 0 {
            viewModel.getDetailAllCategoryAPI(filter: .read)
        } else {
            viewModel.getDetailCategoryAPI(categoryID: viewModel.categoryId, filter: .read)
        }
    }
    
    func setupNotReadLink() {
        viewModel.segmentIndex = 2
        if viewModel.categoryId == 0 {
            viewModel.getDetailAllCategoryAPI(filter: .unread)
        } else {
            viewModel.getDetailCategoryAPI(categoryID: viewModel.categoryId, filter: .unread)
        }
    }
}

// MARK: - DetailClipListCollectionViewCell Delegate

extension DetailClipViewController: DetailClipListCollectionViewCellDelegate {
    func modifiedButtonTapped(toastId: Int) {
        viewModel.toastId = toastId
        bottom.modalPresentationStyle = .overFullScreen
        present(bottom, animated: false)
    }
}

// MARK: - EditLinkBottomSheetView Delegate

extension DetailClipViewController: EditLinkBottomSheetViewDelegate {
    func callCheckAPI(filter: DetailCategoryFilter) {
        viewModel.getDetailAllCategoryAPI(filter: filter)
    }
    
    func addHeightBottom() {
        editLinkBottom.changeHeightBottomSheet(height: 219)
    }
    
    func minusHeightBottom() {
        editLinkBottom.changeHeightBottomSheet(height: 198)
    }
    
    func dismissButtonTapped(title: String) {
        editLinkBottom.hideBottomSheet()
        viewModel.patchEditLinkTitleAPI(toastId: viewModel.toastId,
                                        title: title)
    }
}

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
    
    private var clipList: ClipModel = ClipModel(allClipToastCount: 0, clips: []) {
        didSet {
            clipEmptyView.isHidden = !clipList.clips.isEmpty
            clipListCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    private let clipEmptyView = ClipEmptyView()
    private let addClipBottomSheetView = AddClipBottomSheetView()
    private lazy var addClipBottom = ToasterBottomSheetViewController(bottomType: .white, bottomTitle: "클립 추가", height: 198, insertView: addClipBottomSheetView)
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
        
        getAllCategoryAPI()
        setupNavigationBar()
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
        addClipBottomSheetView.addClipBottomSheetViewDelegate = self
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string(StringLiterals.Tabbar.clip),
                                                                rightButton: StringOrImageType.string("편집"),
                                                                rightButtonAction: editButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func editButtonTapped() {
        let editClipViewController = EditClipViewController()
        editClipViewController.setupDataBind(clipModel: clipList)
        editClipViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editClipViewController, animated: false)
    }
}

// MARK: - CollectionView Delegate

extension ClipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = DetailClipViewController()
        if indexPath.item == 0 {
            nextVC.getDetailAllCategoryAPI(filter: .all)
            nextVC.setupCategory(id: 0, name: "전체 클립")
        } else {
            nextVC.getDetailCategoryAPI(categoryID: clipList.clips[indexPath.item-1].id,
                                        filter: .all)
            nextVC.setupCategory(id: clipList.clips[indexPath.item-1].id,
                                 name: clipList.clips[indexPath.item-1].title)
        }
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CollectionView DataSource

extension ClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clipList.clips.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipListCollectionViewCell.className, for: indexPath) as? ClipListCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.configureCell(forModel: clipList, icon: ImageLiterals.TabBar.allClip.withTintColor(.black900), name: "전체 클립")
        } else {
            cell.configureCell(forModel: clipList, icon: ImageLiterals.TabBar.clip.withTintColor(.black900), index: indexPath.item-1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
            headerView.isDetailClipView(isHidden: false)
            headerView.setupDataBind(title: "전체",
                                     count: clipList.clips.count + 1)
            headerView.clipCollectionHeaderViewDelegate = self
            return headerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - CollectionView Delegate Flow Layout

extension ClipViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: 52)
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

extension ClipViewController: ClipCollectionHeaderViewDelegate {
    func searchBarButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func addClipButtonTapped() {
        if clipList.clips.count >= 15 {
            showToastMessage(width: 243, status: .warning, message: StringLiterals.ToastMessage.noticeMaxClip)
        } else {
            addClipBottom.modalPresentationStyle = .overFullScreen
            self.present(addClipBottom, animated: false)
        }
    }
}

extension ClipViewController: AddClipBottomSheetViewDelegate {
    func addHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 219)
    }
    
    func minusHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 198)
    }
    
    func dismissButtonTapped(title: String) {
        postAddCategoryAPI(requestBody: title)
    }
    
    func callCheckAPI(text: String) {
        getCheckCategoryAPI(categoryTitle: text)
    }
}

// MARK: - Network

extension ClipViewController {
    func getAllCategoryAPI() {
        NetworkService.shared.clipService.getAllCategory { [weak self] result in
            switch result {
            case .success(let response):
                let allClipToastCount = response?.data.toastNumberInEntire
                var clips = [AllClipModel]()
                response?.data.categories.forEach {
                    clips.append(AllClipModel(id: $0.categoryId,
                                              title: $0.categoryTitle,
                                              toastCount: $0.toastNum))
                }
                self?.clipList = ClipModel(allClipToastCount: allClipToastCount ?? 0,
                                           clips: clips)
            case .unAuthorized, .networkFail, .notFound:
                self?.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
    
    func postAddCategoryAPI(requestBody: String) {
        NetworkService.shared.clipService.postAddCategory(requestBody: PostAddCategoryRequestDTO(categoryTitle: requestBody)) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.addClipBottomSheetView.resetTextField()
                    self.addClipBottom.hideBottomSheet()
                    self.showToastMessage(width: 157, status: .check, message: StringLiterals.ToastMessage.completeAddClip)
                }
                self.getAllCategoryAPI()
            case .unAuthorized, .networkFail, .notFound:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
    
    func getCheckCategoryAPI(categoryTitle: String) {
        NetworkService.shared.clipService.getCheckCategory(categoryTitle: categoryTitle) { result in
            switch result {
            case .success(let response):
                if let data = response?.data.isDupicated {
                    if categoryTitle.count != 16 {
                        if data {
                            self.addHeightBottom()
                            self.addClipBottomSheetView.changeTextField(addButton: false, border: true, error: true, clearButton: true)
                            self.addClipBottomSheetView.setupMessage(message: "이미 같은 이름의 클립이 있어요")
                        } else {
                            self.minusHeightBottom()
                        }
                    }
                }
            case .unAuthorized, .networkFail, .notFound:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
}

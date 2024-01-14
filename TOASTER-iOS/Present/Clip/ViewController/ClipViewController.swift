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
    
    private var clipList: GetAllCategoryResponseDTO? {
        didSet {
            clipListCollectionView.reloadData()
        }
    }
    
    private var clipCount: Int = 0          // 클립뷰 헤더에 표출되는 클립의 개수
    private var allToasterCount: Int = 0    // 클립 컬뷰 상단에 고정으로 표출되는 전체클립의 개수
    
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
        
        getDetailCategoryAPI()
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
    
    func setupEmptyView() {
        clipEmptyView.isHidden = clipCount > 0 ? true : false
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
        let editClipViewController = EditClipViewController()
        editClipViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editClipViewController, animated: false)
    }
}

// MARK: - CollectionView Delegate

extension ClipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = DetailClipViewController()
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - CollectionView DataSource

extension ClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = clipList?.data.count else { return 1 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipListCollectionViewCell.className, for: indexPath) as? ClipListCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.configureCell(forModel: GetAllCategoryResponseData(categoryId: 0, categoryTitle: "전체클립", toastNum: allToasterCount), icon: ImageLiterals.TabBar.allClip.withTintColor(.black900))
        } else {
            if let clips = clipList?.data[indexPath.row] {
                cell.configureCell(forModel: clips, icon: ImageLiterals.TabBar.clip.withTintColor(.black900))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ClipCollectionHeaderView.className, for: indexPath) as? ClipCollectionHeaderView else { return UICollectionReusableView() }
            headerView.isDetailClipView(isHidden: false)
            headerView.setupDataBind(count: clipCount)
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
        addClipBottom.modalPresentationStyle = .overFullScreen
        self.present(addClipBottom, animated: false)
    }
}

extension ClipViewController: AddClipBottomSheetViewDelegate {
    func addHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 219)
    }
    
    func minusHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 198)
    }
    
    func dismissButtonTapped(text: PostAddCategoryRequestDTO) {
        postAddCategoryAPI(requestBody: text)
        addClipBottom.hideBottomSheet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showToastMessage(width: 157, status: .check, message: "클립 생성 완료!")
            self.addClipBottomSheetView.resetTextField()
            self.clipListCollectionView.reloadData()
        }
    }
}

// MARK: - Network

extension ClipViewController {
    func getDetailCategoryAPI() {
        NetworkService.shared.clipService.getAllCategory { result in
            switch result {
            case .success(let response):
                self.clipList = response
                if let data = response?.data {
                    self.clipCount = data.count
                    self.setupEmptyView()
                }
            default: return
            }
        }
    }
    
    func postAddCategoryAPI(requestBody: PostAddCategoryRequestDTO) {
        NetworkService.shared.clipService.postAddCategory(requestBody: requestBody) { result in
            switch result {
            case .success:
                self.clipListCollectionView.reloadData()
            default: return
            }
        }
    }
    
    func getCheckCategoryAPI() {
        
    }
}

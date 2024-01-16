//
//  HomeViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//
import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let homeView = HomeView()
    private let mainCollectionViewCell = MainCollectionViewCell()
    
    
    private var clipList: MainInfoModel {
        didSet {
            homeView.collectionView.reloadData()
        }
    }
    
    private let addClipBottomSheetView = AddClipBottomSheetView()
    private lazy var addClipBottom = ToasterBottomSheetViewController(bottomType: .white, bottomTitle: "클립 추가", height: 198, insertView: addClipBottomSheetView)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.backgroundColor = .toasterBackground
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension HomeViewController: UICollectionViewDelegate {}
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return 9
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.className, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            cell.bindData(forModel: MainInfoModel )
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserClipCollectionViewCell.className, for: indexPath) as? UserClipCollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                cell.configureCell(forModel: CategoryList(categoryId: 0, categroyTitle: "전체클립", toastNum: 100), icon: ImageLiterals.Home.clipDefault.withTintColor(.black900))
            } else {
                cell.configureCell(forModel: dummyCategoryInfo[indexPath.row], icon: ImageLiterals.Home.clipFull.withTintColor(.black900))
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyLinkCollectionViewCell.className, for: indexPath) as? WeeklyLinkCollectionViewCell
            else { return UICollectionViewCell() }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyRecommendCollectionViewCell.className, for: indexPath) as? WeeklyRecommendCollectionViewCell
            else { return UICollectionViewCell() }
            return cell
        default:
            return MainCollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == clipCellData.count - 1 {
            addClipCellTapped()
        }
    }
    
    // Header, Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            // header
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderCollectionView.className, for: indexPath) as? HomeHeaderCollectionView else { return UICollectionReusableView() }
            switch indexPath.section {
            case 1:
                header.configureHeader(forTitle: "토스터 님의 클립")
            case 2:
                header.configureHeader(forTitle: "이주의 링크")
            case 3:
                header.configureHeader(forTitle: "이주의 추천 사이트")
            default: break
            }
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeFooterCollectionView.className, for: indexPath) as? HomeFooterCollectionView else { return UICollectionReusableView() }
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
    // Header 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 335, height: 40)
    }
    
    // Footer 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 4)
    }
}

// MARK: - Private Extensions

private extension HomeViewController {
    func setupHierarchy() {
        view.addSubview(homeView.collectionView)
    }
    
    func setupLayout() {
        homeView.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createCollectionView() {
        let homeCollectionView = homeView.collectionView
        homeCollectionView.backgroundColor = .toasterBackground
        homeCollectionView.alwaysBounceVertical = true
        
        homeCollectionView.do {
            $0.register(MainCollectionViewCell.self,
                        forCellWithReuseIdentifier: MainCollectionViewCell.className)
            $0.register(UserClipCollectionViewCell.self,
                        forCellWithReuseIdentifier: UserClipCollectionViewCell.className)
            $0.register(WeeklyLinkCollectionViewCell.self,
                        forCellWithReuseIdentifier: WeeklyLinkCollectionViewCell.className)
            $0.register(WeeklyRecommendCollectionViewCell.self,
                        forCellWithReuseIdentifier: WeeklyRecommendCollectionViewCell.className)
            $0.register(UserClipEmptyCollectionViewCell.self,
                        forCellWithReuseIdentifier: UserClipEmptyCollectionViewCell.className)
            
            // header
            $0.register(HomeHeaderCollectionView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: HomeHeaderCollectionView.className)
            
            // footer
            $0.register(HomeFooterCollectionView.self,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                        withReuseIdentifier: HomeFooterCollectionView.className)
        }
        addClipBottomSheetView.addClipBottomSheetViewDelegate = self
    }
    
    func setupDelegate() {
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.image(ImageLiterals.Logo.wordmark),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.setting),
                                                                rightButtonAction: rightButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func rightButtonTapped() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func setView() {
        setupHierarchy()
        setupLayout()
        createCollectionView()
        setupDelegate()
    }
    
    func fetchMainPageData() {
        NetworkService.shared.userService.getMainPage { [weak self] result in
            switch result { // response ==> GetMainPageResponseDTO?
            case .success(let response):
                if let responseData = response?.data {
                    DispatchQueue.main.async { [weak self] in
                        self?.mainCollectionViewCell.bindData(forModel: MainInfoModel(nickname: responseData.nickname, readToastNum: responseData.readToastNum, allToastNum: responseData.allToastNum, mainCategoryListDto:))
                    }
                }
            case .networkFail:
                // skip
                print("NETWORK FAIL...")
            default:
                print("default fail")
            }
        }
    }
}

extension HomeViewController: AddClipBottomSheetViewDelegate {
    func addHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 219)
    }
    
    func minusHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 198)
    }
    
    func dismissButtonTapped() {
        addClipBottom.hideBottomSheet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showToastMessage(width: 157, status: .check, message: "클립 생성 완료!")
            self.addClipBottomSheetView.resetTextField()
        }
    }
}

extension HomeViewController: UserClipCollectionViewCellDelegate {
    func addClipCellTapped() {
        addClipBottom.modalPresentationStyle = .overFullScreen
        self.present(addClipBottom, animated: false)
    }
}

// MARK: - Network

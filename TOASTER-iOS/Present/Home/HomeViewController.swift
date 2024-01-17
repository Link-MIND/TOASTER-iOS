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

    private var mainInfoList: MainInfoModel? {
        didSet {
            homeView.collectionView.reloadData()
        }
    }
    
    private var weeklyLinkList: [WeeklyLinkModel]? {
        didSet {
            homeView.collectionView.reloadData()
        }
    }
    
    private var recommendSiteList: [RecommendSiteModel]? {
        didSet {
            homeView.collectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties

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
        
        fetchMainPageData()
        fetchWeeklyLinkData()
        fetchRecommendSiteData()
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            print(mainInfoList?.mainCategoryListDto[indexPath.item].categoryId)
        case 2:
            let nextVC = LinkWebViewController()
            nextVC.hidesBottomBarWhenPushed = true
            if let data = weeklyLinkList?[indexPath.item] {
                nextVC.setupDataBind(linkURL: data.toastLink)
            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 3:
            let nextVC = LinkWebViewController()
            nextVC.hidesBottomBarWhenPushed = true
            if let data = recommendSiteList?[indexPath.item],
               let url = data.siteUrl {
                nextVC.setupDataBind(linkURL: url)
            }
            self.navigationController?.pushViewController(nextVC, animated: true)
        default: break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            guard let count = mainInfoList?.mainCategoryListDto.count else { return 1 }
            return min(count + 1, 4)
        case 2:
            return weeklyLinkList?.count ?? 0
        case 3:
            return recommendSiteList?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.className, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            if let model = mainInfoList {
                cell.bindData(forModel: model)
            }
            cell.mainCollectionViewDelegate = self
            return cell
        case 1:
            let lastIndex = mainInfoList?.mainCategoryListDto.count ?? 0
            
            if indexPath.item == lastIndex {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserClipEmptyCollectionViewCell.className, for: indexPath) as? UserClipEmptyCollectionViewCell else { return UICollectionViewCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserClipCollectionViewCell.className, for: indexPath) as? UserClipCollectionViewCell else { return UICollectionViewCell() }
                
                if let model = mainInfoList?.mainCategoryListDto {
                    if indexPath.item == 0 {
                        cell.bindData(forModel: model[indexPath.item], icon: ImageLiterals.Home.clipDefault.withTintColor(.black900))
                    } else {
                        cell.bindData(forModel: model[indexPath.item], icon: ImageLiterals.Home.clipFull)
                    }
                }
                return cell
            }
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyLinkCollectionViewCell.className, for: indexPath) as? WeeklyLinkCollectionViewCell
            else { return UICollectionViewCell() }
            if let model = weeklyLinkList {
                cell.bindData(forModel: model[indexPath.item])
            }
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyRecommendCollectionViewCell.className, for: indexPath) as? WeeklyRecommendCollectionViewCell
            else { return UICollectionViewCell() }
            if let model = recommendSiteList {
                cell.bindData(forModel: model[indexPath.item])
            }
            return cell
        default:
            return MainCollectionViewCell()
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
                if let nickName = mainInfoList?.nickname {
                    header.configureHeader(forTitle: nickName + " 님의 클립")
                }
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
    
}

// MARK: - AddClipBottomSheetViewDelegate

extension HomeViewController: AddClipBottomSheetViewDelegate {
    func callCheckAPI(text: String) {
        // getCheckCategoryAPI(categoryTitle: text)
    }
    
    func addHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 219)
    }
    
    func minusHeightBottom() {
        addClipBottom.changeHeightBottomSheet(height: 198)
    }
    
    func dismissButtonTapped(text: PostAddCategoryRequestDTO) {
        addClipBottom.hideBottomSheet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showToastMessage(width: 157, status: .check, message: "클립 생성 완료!")
            self.addClipBottomSheetView.resetTextField()
        }
    }
}

// MARK: - UserClipCollectionViewCellDelegate

extension HomeViewController: UserClipCollectionViewCellDelegate {
    func addClipCellTapped() {
        addClipBottom.modalPresentationStyle = .overFullScreen
        self.present(addClipBottom, animated: false)
    }
}

// MARK: - MainCollectionViewDelegate

extension HomeViewController: MainCollectionViewDelegate {
    func searchButtonTapped() {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - Network

extension HomeViewController {
    // 메인페이지 + 유저 정보 + 클립 조회 -> GET
    func fetchMainPageData() {
        NetworkService.shared.userService.getMainPage { result in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    var categoryList: [CategoryList] = [CategoryList(categoryId: 0,
                                                                     categroyTitle: "전체 클립",
                                                                     toastNum: data.allToastNum)]
                    data.mainCategoryListDto.forEach {
                        categoryList.append(CategoryList(categoryId: $0.categoryId,
                                                         categroyTitle: $0.categoryTitle,
                                                         toastNum: $0.toastNum))
                    }
                    self.mainInfoList = MainInfoModel(nickname: data.nickname,
                                                      readToastNum: data.readToastNum,
                                                      allToastNum: data.allToastNum,
                                                      mainCategoryListDto: categoryList)
                }
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default:
                return
            }
        }
    }
    
    // 이주의 링크 -> GET
    func fetchWeeklyLinkData() {
        NetworkService.shared.toastService.getWeeksLink { result in
            switch result {
            case .success(let response):
                var list: [WeeklyLinkModel] = []
                if let data = response?.data {
                    for idx in 0..<data.count {
                        list.append(WeeklyLinkModel(toastId: data[idx].linkId,
                                                    toastTitle: data[idx].linkTitle,
                                                    toastImg: data[idx].linkImg ?? "",
                                                    toastLink: data[idx].linkUrl))
                    }
                    self.weeklyLinkList = list
                }
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default:
                return
            }
        }
    }
    
    // 추천 사이트 -> GET
    func fetchRecommendSiteData() {
        NetworkService.shared.searchService.getRecommendSite { result in
            switch result {
            case .success(let response):
                var list: [RecommendSiteModel] = []
                if let data = response?.data {
                    for idx in 0..<data.count {
                        list.append(RecommendSiteModel(siteId: data[idx].siteId,
                                                       siteTitle: data[idx].siteTitle,
                                                       siteUrl: data[idx].siteUrl,
                                                       siteImg: data[idx].siteImg,
                                                       siteSub: data[idx].siteSub))
                    }
                    self.recommendSiteList = list
                }
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default:
                return
            }
        }
    }
}

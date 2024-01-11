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
    
    var clipCellData = dummyCategoryInfo
    
    private let addClipBottomSheetView = AddClipBottomSheetView()
    private lazy var addClipBottom = ToasterBottomSheetViewController(bottomType: .white, bottomTitle: "클립 추가", height: 219, insertView: addClipBottomSheetView)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.backgroundColor = .toasterBackground
        setView()
    }
    
    // MARK: - set View
    
    private func setView() {
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        createCollectionView()
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
            return clipCellData.count
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
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserClipCollectionViewCell.className, for: indexPath) as? UserClipCollectionViewCell else { return UICollectionViewCell() }
            if indexPath.row == 0 {
                cell.configureCell(forModel: CategoryList(categoryId: 0, categroyTitle: "전체클립", toastNum: 100))
            } else {
                cell.configureCell(forModel: dummyCategoryInfo[indexPath.row])
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyLinkCollectionViewCell.className, for: indexPath) as? WeeklyLinkCollectionViewCell
            else { return UICollectionViewCell() }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyRecommendCollectionViewCell.className, for: indexPath) as? WeeklyRecommendCollectionViewCell
            else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == clipCellData.count - 1 {
            addClipCellTapped()
        }
    }
    
    // Header, Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MainFooterCollectionView.className, for: indexPath) as? MainFooterCollectionView
            else { return MainFooterCollectionView() }
            footer.configure()
            return footer
        case 1:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserClipHeaderCollectionView.className, for: indexPath) as? UserClipHeaderCollectionView else {
                    return UserClipHeaderCollectionView()
                }
                header.configure()
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UserClipFooterCollectionView.className, for: indexPath) as? UserClipFooterCollectionView else {
                    return UserClipFooterCollectionView()
                }
                footer.configure()
                return footer
            }
        case 2:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeeklyLinkHeaderCollectionView.className, for: indexPath) as? WeeklyLinkHeaderCollectionView else {
                    return WeeklyLinkHeaderCollectionView()
                }
                header.configure()
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: WeeklyLinkFooterCollectionView.className, for: indexPath) as? WeeklyLinkFooterCollectionView else {
                    return WeeklyLinkFooterCollectionView()
                }
                footer.configure()
                return footer
            }
        case 3:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeeklyRecommendHeaderCollectionView.className, for: indexPath) as? WeeklyRecommendHeaderCollectionView
            else { return WeeklyRecommendHeaderCollectionView() }
            header.configure()
            return header
        default:
            return UserClipHeaderCollectionView()
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
        
        // Cell register
        homeCollectionView.register(MainCollectionViewCell.self,
                                    forCellWithReuseIdentifier: MainCollectionViewCell.className)
        homeCollectionView.register(UserClipCollectionViewCell.self,
                                    forCellWithReuseIdentifier: UserClipCollectionViewCell.className)
        homeCollectionView.register(WeeklyLinkCollectionViewCell.self,
                                    forCellWithReuseIdentifier: WeeklyLinkCollectionViewCell.className)
        homeCollectionView.register(WeeklyRecommendCollectionViewCell.self,
                                    forCellWithReuseIdentifier: WeeklyRecommendCollectionViewCell.className)
        homeCollectionView.register(UserClipEmptyCollectionViewCell.self,forCellWithReuseIdentifier: UserClipEmptyCollectionViewCell.className)
        
        // Header register
        homeCollectionView.register(UserClipHeaderCollectionView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: UserClipHeaderCollectionView.className)
        
        homeCollectionView.register(WeeklyLinkHeaderCollectionView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: WeeklyLinkHeaderCollectionView.className)
        
        homeCollectionView.register(WeeklyRecommendHeaderCollectionView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: WeeklyRecommendHeaderCollectionView.className)
        
        // Footer register
        homeCollectionView.register(MainFooterCollectionView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: MainFooterCollectionView.className)
        homeCollectionView.register(UserClipFooterCollectionView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: UserClipFooterCollectionView.className)
        homeCollectionView.register(WeeklyLinkFooterCollectionView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: WeeklyLinkFooterCollectionView.className)
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        addClipBottomSheetView.addClipBottomSheetViewDelegate = self
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
        // rightButtonAction - 환경설정 화면 구현 완료 이후 수정할 예정
        print("환경설정")
    }
}

extension HomeViewController: AddClipBottomSheetViewDelegate {
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

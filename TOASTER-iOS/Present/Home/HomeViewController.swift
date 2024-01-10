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
    
    private let homeView = HomeView()
    var clipCellData = dummyCategoryInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.backgroundColor = .toasterBackground
        setView()
    }
    
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
            return 4
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
    
    // Header, Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MainFooterCollectionReusableView.className, for: indexPath) as? MainFooterCollectionReusableView
            else { return MainFooterCollectionReusableView() }
            footer.configure()
            return footer
        case 1:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UserClipHeaderCollectionReusableView.className, for: indexPath) as? UserClipHeaderCollectionReusableView else {
                    return UserClipHeaderCollectionReusableView()
                }
                header.configure()
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UserClipFooterCollectionReusableView.className, for: indexPath) as? UserClipFooterCollectionReusableView else {
                    return UserClipFooterCollectionReusableView()
                }
                footer.configure()
                return footer
            }
        case 2:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeeklyLinkHeaderCollectionReusableView.className, for: indexPath) as? WeeklyLinkHeaderCollectionReusableView else {
                    return WeeklyLinkHeaderCollectionReusableView()
                }
                header.configure()
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: WeeklyLinkFooterCollectionReusableView.className, for: indexPath) as? WeeklyLinkFooterCollectionReusableView else {
                    return WeeklyLinkFooterCollectionReusableView()
                }
                footer.configure()
                return footer
            }
        case 3:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeeklyRecommendHeaderCollectionReusableView.className, for: indexPath) as? WeeklyRecommendHeaderCollectionReusableView
            else { return WeeklyRecommendHeaderCollectionReusableView() }
            header.configure()
            return header
        default:
            return UserClipHeaderCollectionReusableView()
        }
    }
    
    // Header 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 300, height: 40)
        case 1:
            return CGSize(width: 300, height: 40)
        default:
            return CGSize(width: 300, height: 40)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: 335, height: 4)
        case 1:
            return CGSize(width: 335, height: 4)
        default:
            return CGSize(width: 335, height: 4)
        }
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
        
        // Header register
        homeCollectionView.register(UserClipHeaderCollectionReusableView.self,
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: UserClipHeaderCollectionReusableView.className)
        
        homeCollectionView.register(WeeklyLinkHeaderCollectionReusableView.self,
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: WeeklyLinkHeaderCollectionReusableView.className)
        
        homeCollectionView.register(WeeklyRecommendHeaderCollectionReusableView.self,
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: WeeklyRecommendHeaderCollectionReusableView.className)
        
        // Footer register
        homeCollectionView.register(MainFooterCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: MainFooterCollectionReusableView.className)
        homeCollectionView.register(UserClipFooterCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: UserClipFooterCollectionReusableView.className)
        homeCollectionView.register(WeeklyLinkFooterCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: WeeklyLinkFooterCollectionReusableView.className)
        
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
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
         // rightButtonAction
        print("환경설정")
     }
}

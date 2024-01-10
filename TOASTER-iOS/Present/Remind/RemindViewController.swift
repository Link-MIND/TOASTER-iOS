//
//  RemindViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class RemindViewController: UIViewController {

    // MARK: - UI Properties

    private let timerCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
}

// MARK: - Private Extensions

private extension RemindViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        
        timerCollectionView.do {
            $0.backgroundColor = .toasterBackground
            
            $0.register(CompleteTimerCollectionViewCell.self, forCellWithReuseIdentifier: CompleteTimerCollectionViewCell.className)
            $0.register(WaitTimerCollectionViewCell.self, forCellWithReuseIdentifier: WaitTimerCollectionViewCell.className)
            
            $0.register(RemindCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RemindCollectionHeaderView.className)
            $0.register(RemindCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RemindCollectionFooterView.className)
        }
    }
    
    func setupHierarchy() {
        view.addSubview(timerCollectionView)
    }
    
    func setupLayout() {
        timerCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        timerCollectionView.delegate = self
        timerCollectionView.dataSource = self
    }
    
    func setupNavigationBar() {
         let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                 hasRightButton: true,
                                                                 mainTitle: StringOrImageType.string("TIMER"),
                                                                 rightButton: StringOrImageType.image(ImageLiterals.Common.plus),
                                                                 rightButtonAction: plusButtonTapped)
                                                                 
        if let navigationController = navigationController as? ToasterNavigationController {
              navigationController.setupNavigationBar(forType: type)
        }
     }

    func plusButtonTapped() {
         // plusButtonTapped
     }
}

// MARK: - UICollectionViewDelegate

extension RemindViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension RemindViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompleteTimerCollectionViewCell.className, for: indexPath) as? CompleteTimerCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitTimerCollectionViewCell.className, for: indexPath) as? WaitTimerCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RemindCollectionHeaderView.className, for: indexPath) as? RemindCollectionHeaderView else { return UICollectionReusableView() }
                header.configureHeader(forTitle: "완료된 타이머",
                                       forTimerCount: 5,
                                       forCountLabelHidden: false)
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RemindCollectionFooterView.className, for: indexPath) as? RemindCollectionFooterView else { return UICollectionReusableView() }
                return footer
            }
        case 1:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RemindCollectionHeaderView.className, for: indexPath) as? RemindCollectionHeaderView else { return UICollectionReusableView() }
                header.configureHeader(forTitle: "타이머 대기 중..",
                                       forCountLabelHidden: true)
                return header
            } else { return UICollectionReusableView() }
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.getDeviceWidth(), height: 22)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 0: return CGSize(width: view.getDeviceWidth(), height: 28)
        default: return .zero
        }
    }
}

extension RemindViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.convertByWidthRatio(335), height: 100)
        case 1:
            return CGSize(width: collectionView.convertByWidthRatio(335), height: 109)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 20, bottom: 24, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0: return 12
        case 1: return 18
        default: return 0
        }
    }
}

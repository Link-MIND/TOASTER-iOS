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

    // MARK: - Properties

    private let viewModel = RemindViewModel()
    
    // MARK: - UI Properties

    private let timerCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupViewModel()
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
    
    func setupViewModel() {
        viewModel.setupDataChangeAction {
            self.timerCollectionView.reloadData()
        }
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
    
    func setupBottomSheet() {
        let editView = RemindTimerEditView()
        editView.setupDelegate(forDelegate: self)
        
        let exampleBottom = ToasterBottomSheetViewController(bottomType: .gray, bottomTitle: "수정하기", height: 226, insertView: editView)
        exampleBottom.modalPresentationStyle = .overFullScreen
        
        present(exampleBottom, animated: false)
    }
    
    func deleteButtonTapped() {
        
        // TODO: - Delete API 연결
        
        dismiss(animated: false)
        showToastMessage(width: 165, status: .check, message: "타이머 삭제 완료")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RemindViewController: RemindEditViewDelegate {
    func editTimer() {

        // TODO: - Edit 로직
        
        dismiss(animated: false)
    }
    
    func deleteTimer() {
        dismiss(animated: false)
        showPopup(forMainText: "타이머를 삭제하시겠어요?",
                  forSubText: "더 이상 해당 클립의 리마인드를 \n받을 수 없어요",
                  forLeftButtonTitle: "취소",
                  forRightButtonTitle: "삭제",
                  forRightButtonHandler: deleteButtonTapped)
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
        switch section {
        case 0: return viewModel.timerData.completeTimerModelList.count
        case 1: return viewModel.timerData.waitTimerModelList.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompleteTimerCollectionViewCell.className, for: indexPath) as? CompleteTimerCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(forModel: viewModel.timerData.completeTimerModelList[indexPath.item])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitTimerCollectionViewCell.className, for: indexPath) as? WaitTimerCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(forModel: viewModel.timerData.waitTimerModelList[indexPath.item],
                               forAction: setupBottomSheet)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        // header
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RemindCollectionHeaderView.className, for: indexPath) as? RemindCollectionHeaderView else { return UICollectionReusableView() }
            switch indexPath.section {
            case 0:
                header.configureHeader(forTitle: "완료된 타이머",
                                       forTimerCount: viewModel.timerData.completeTimerModelList.count)
            case 1:
                header.configureHeader(forTitle: "타이머 대기 중..")
            default: break
            }
            return header
        // footer
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RemindCollectionFooterView.className, for: indexPath) as? RemindCollectionFooterView else { return UICollectionReusableView() }
            return footer
        default: return UICollectionReusableView()
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

// MARK: - UICollectionViewDelegateFlowLayout

extension RemindViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: collectionView.convertByWidthRatio(335), height: 100)
        case 1: return CGSize(width: collectionView.convertByWidthRatio(335), height: 109)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 20, bottom: 24, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0: return 18
        case 1: return 12
        default: return 0
        }
    }
}

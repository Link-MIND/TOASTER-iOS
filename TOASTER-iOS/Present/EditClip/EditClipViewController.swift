//
//  EditClipViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class EditClipViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let editClipNoticeView = EditClipNoticeView()
    private let editClipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let editClipBottomSheetView = AddClipBottomSheetView()
    private lazy var editClipBottom = ToasterBottomSheetViewController(bottomType: .white,
                                                                       bottomTitle: "클립 이름 수정",
                                                                       height: 219,
                                                                       insertView: editClipBottomSheetView)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
}

// MARK: - Private Extensions

private extension EditClipViewController {
    func setupStyle() {
        editClipCollectionView.do {
            $0.backgroundColor = .toasterBackground
            $0.delegate = self
            $0.dataSource = self
            $0.register(EditClipCollectionViewCell.self, forCellWithReuseIdentifier: EditClipCollectionViewCell.className)
        }
        
        editClipBottomSheetView.do {
            $0.addClipBottomSheetViewDelegate = self
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(editClipNoticeView, editClipCollectionView)
    }
    
    func setupLayout() {
        editClipNoticeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        editClipCollectionView.snp.makeConstraints {
            $0.top.equalTo(editClipNoticeView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true, hasRightButton: false, mainTitle: StringOrImageType.string("CLIP 편집"), rightButton: StringOrImageType.string(""), rightButtonAction: {})
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func popupDeleteButtonTapped() {
        // 삭제 서버 통신 붙일 부분
        dismiss(animated: false) {
            self.showToastMessage(width: 152, status: .check, message: "클립 삭제 완료")
        }
    }
}

// MARK: - CollectionView DataSource

extension EditClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyClipList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditClipCollectionViewCell.className, for: indexPath) as? EditClipCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.configureCell(forModel: ClipListModel(categoryID: 0, categoryTitle: "전체클립",
                                                       toastNum: 100), 
                               icon: ImageLiterals.Clip.pin,
                               isFirst: true)
        } else {
            cell.configureCell(forModel: dummyClipList[indexPath.row-1], 
                               icon: ImageLiterals.Clip.delete,
                               isFirst: false)
            
            cell.leadingButtonTapped {
                self.showPopup(forMainText: "‘\(dummyClipList[indexPath.row-1].categoryTitle)’ 클립을 삭제하시겠어요?",
                               forSubText: "지금까지 저장된 모든 링크가 사라져요",
                               forLeftButtonTitle: "닫기",
                               forRightButtonTitle: "삭제",
                               forRightButtonHandler: self.popupDeleteButtonTapped)
            }
            
            cell.changeTitleButtonTapped {
                self.editClipBottom.modalPresentationStyle = .overFullScreen
                self.present(self.editClipBottom, animated: false)
            }
        }
        return cell
    }
}

// MARK: - CollectionView Delegate

extension EditClipViewController: UICollectionViewDelegate {}

// MARK: - CollectionView Delegate Flow Layout

extension EditClipViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: 54)
    }
    
    // ContentInset: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // minimumLineSpacing: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - AddClipBottomSheetView Delegate

extension EditClipViewController: AddClipBottomSheetViewDelegate {
    func dismissButtonTapped() {
        // 수정 서버 통신 붙일 부분
        editClipBottom.hideBottomSheet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showToastMessage(width: 157, status: .check, message: "클립 수정 완료!")
            self.editClipBottomSheetView.resetTextField()
        }
    }
}

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

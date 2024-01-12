//
//  TimerRepeatBottomSheetView.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/11/24.
//

import UIKit

import SnapKit
import Then

final class TimerRepeatBottomSheetView: UIView {

    // MARK: - Components
    
    private let repeatTime: [TimerRepeatDate] = [.everyDay,
                                                 .everyWeekDay,
                                                 .everyWeekend,
                                                 .mon,
                                                 .tue,
                                                 .wed,
                                                 .thu,
                                                 .fri,
                                                 .sat,
                                                 .sun]
    private var selectedList: Set<Int> = []

    // MARK: - UI Components

    private lazy var repeatCollectionView: UICollectionView = createCollectionView()
    private let nextButton: UIButton = UIButton()
    
    // MARK: - Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension TimerRepeatBottomSheetView {
    func setupStyle() {
        backgroundColor = .gray50
        
        repeatCollectionView.do {
            $0.register(TimerRepeatCollectionViewCell.self, forCellWithReuseIdentifier: TimerRepeatCollectionViewCell.className)
            $0.makeRounded(radius: 12)
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .gray50
        }
        
        nextButton.do {
            $0.backgroundColor = .black850
            $0.makeRounded(radius: 12)
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
        }
    }
    
    func setupHierarchy() {
        addSubviews(repeatCollectionView, nextButton)
    }
    
    func setupLayout() {
        repeatCollectionView.snp.makeConstraints {
            $0.height.equalTo(540)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.top.equalTo(repeatCollectionView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setupDelegate() {
        repeatCollectionView.delegate = self
        repeatCollectionView.dataSource = self
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 335, height: 53)
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }
}

// MARK: - UICollectionViewDelegate

extension TimerRepeatBottomSheetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TimerRepeatCollectionViewCell else { return }
        
        cell.cellSelected(forSelect: selectedList.contains(indexPath.item))
        if selectedList.contains(indexPath.item) {
            selectedList.remove(indexPath.item)
        } else { selectedList.insert(indexPath.item) }
    }
}

// MARK: - UICollectionViewDataSource

extension TimerRepeatBottomSheetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repeatTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimerRepeatCollectionViewCell.className, for: indexPath) as? TimerRepeatCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(forModel: repeatTime[indexPath.item])
        cell.cellSelected(forSelect: selectedList.contains(indexPath.item))
        return cell
    }
}

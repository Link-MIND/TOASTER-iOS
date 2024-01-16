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
    
    // MARK: - Properties
    
    private var clipList: GetAllCategoryResponseDTO? {
        didSet {
            editClipCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    private let editClipNoticeView = EditClipNoticeView()
    private let editClipCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let editClipBottomSheetView = AddClipBottomSheetView()
    private lazy var editClipBottom = ToasterBottomSheetViewController(bottomType: .white,
                                                                       bottomTitle: "클립 이름 수정",
                                                                       height: 198,
                                                                       insertView: editClipBottomSheetView)
    
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

// MARK: - Extensions

extension EditClipViewController {
    func setupDataBind(getAllCategoryResponseDTO: GetAllCategoryResponseDTO) {
        clipList = getAllCategoryResponseDTO
    }
}

// MARK: - Private Extensions

private extension EditClipViewController {
    func setupStyle() {
        editClipCollectionView.do {
            $0.backgroundColor = .toasterBackground
            $0.register(EditClipCollectionViewCell.self, forCellWithReuseIdentifier: EditClipCollectionViewCell.className)
            $0.dragInteractionEnabled = true
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
    
    func setupDelegate() {
        editClipCollectionView.delegate = self
        editClipCollectionView.dataSource = self
        editClipCollectionView.dragDelegate = self
        editClipCollectionView.dropDelegate = self
    }
    
    func popupDeleteButtonTapped(categoryID: Int, index: Int) {
        deleteCategoryAPI(requestBody: DeleteCategoryRequestDTO.init(deleteCategoryList: [categoryID]))
    }
}

// MARK: - CollectionView DataSource

extension EditClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = clipList?.data { return data.categories.count+1 }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditClipCollectionViewCell.className, for: indexPath) as? EditClipCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.configureCell(forModel: GetAllCategoryData(categoryId: 0, categoryTitle: "전체클립", toastNum: 0),
                               icon: ImageLiterals.Clip.pin, isFirst: true)
        } else {
            if let clips = clipList?.data {
                cell.configureCell(forModel: clips.categories[indexPath.row-1],
                                   icon: ImageLiterals.Clip.delete,
                                   isFirst: false)
                
                cell.leadingButtonTapped {
                    self.showPopup(forMainText: "‘\(clips.categories[indexPath.row-1].categoryTitle)’ 클립을 삭제하시겠어요?",
                                   forSubText: "지금까지 저장된 모든 링크가 사라져요",
                                   forLeftButtonTitle: "닫기",
                                   forRightButtonTitle: "삭제",
                                   forRightButtonHandler: { self.popupDeleteButtonTapped(categoryID: clips.categories[indexPath.row-1].categoryId, index: indexPath.row-1) })
                }
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

// MARK: - CollectionView Drag Delegate

extension EditClipViewController: UICollectionViewDragDelegate {
    /// 처음 드래그가 시작될 때 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return indexPath.item != 0 ? [UIDragItem(itemProvider: NSItemProvider())] : []
    }
}

// MARK: - CollectionView Drop Delegate

extension EditClipViewController: UICollectionViewDropDelegate {
    /// 드래그 하는 동안 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard collectionView.hasActiveDrag else { return UICollectionViewDropProposal(operation: .forbidden) }
        if destinationIndexPath?.item != 0 {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    /// 드래그가 끝나고 드랍할 때 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row, section: 0)
        }
        // 0번째 인덱스 드랍이 아닌 경우, 배열과 컬뷰 아이템 삭제, 삽입, reload까지 진행
           if destinationIndexPath.item != 0 {
               guard let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath else { return }
               collectionView.performBatchUpdates {
                   if var clips = clipList?.data {
                       let sourceItem = clips.categories.remove(at: sourceIndexPath.item - 1)
                       clips.categories.insert(sourceItem, at: destinationIndexPath.item - 1)
                       clipList?.data.categories = clips.categories
                   }
                   collectionView.deleteItems(at: [sourceIndexPath])
                   collectionView.insertItems(at: [destinationIndexPath])
                   coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
               } completion: { _ in
                   collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
               }
           }
    }
}

// MARK: - AddClipBottomSheetView Delegate

extension EditClipViewController: AddClipBottomSheetViewDelegate {
    func callCheckAPI(text: String) {
        getCheckCategoryAPI(categoryTitle: text)
    }
    
    func addHeightBottom() {
        editClipBottom.changeHeightBottomSheet(height: 219)
    }
    
    func minusHeightBottom() {
        editClipBottom.changeHeightBottomSheet(height: 198)
    }
    
    func dismissButtonTapped(text: PostAddCategoryRequestDTO) {
        editClipBottom.hideBottomSheet()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showToastMessage(width: 157, status: .check, message: "클립 수정 완료!")
            self.editClipBottomSheetView.resetTextField()
        }
    }
}

// MARK: - Network

extension EditClipViewController {
    func getAllCategoryAPI() {
        NetworkService.shared.clipService.getAllCategory { result in
            switch result {
            case .success(let response):
                self.clipList = response
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
    
    func deleteCategoryAPI(requestBody: DeleteCategoryRequestDTO) {
        NetworkService.shared.clipService.deleteCategory(requestBody: requestBody) { result in
            switch result {
            case .success:
                self.getAllCategoryAPI()
                self.dismiss(animated: false) {
                    self.showToastMessage(width: 152, status: .check, message: "클립 삭제 완료")
                }
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
    
    func patchEditCategoryAPI(requestBody: PatchEditCategoryRequestDTO) {
        NetworkService.shared.clipService.patchEditCategory(requestBody: requestBody) { result in
            switch result {
            case .success:
                return
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
    
    func getCheckCategoryAPI(categoryTitle: String) {
        NetworkService.shared.clipService.getCheckCategory(categoryTitle: categoryTitle) { result in
            switch result {
            case .success(let response):
                if let data = response?.data.isDupicated {
                    if categoryTitle.count != 16 {
                        if data {
                            self.addHeightBottom()
                            self.editClipBottomSheetView.changeTextField(addButton: false, border: true, error: true, clearButton: true)
                            self.editClipBottomSheetView.setupMessage(message: "이미 같은 이름의 클립이 있어요")
                        } else {
                            self.minusHeightBottom()
                        }
                    }
                }
            case .unAuthorized, .networkFail:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }
}

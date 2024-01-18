//
//  SelectClipViewController.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/01/15.
//

import UIKit

import SnapKit
import Then

final class SelectClipViewController: UIViewController {
    
    // MARK: - Properties
    
    var linkURL = String()
    private var categoryID: Int?
    weak var delegate: SaveLinkButtonDelegate?
        
    // MARK: - Data
    
    // GET
    private var selectedClip: [RemindClipModel] = [] {
        didSet {
            completeButton.backgroundColor = .toasterBlack
            clipSelectCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Properties
    
    private let clipSelectCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let completeButton: UIButton = UIButton()
    private let addClipBottomSheetView = AddClipBottomSheetView()
    private lazy var addClipBottom = ToasterBottomSheetViewController(bottomType: .white, bottomTitle: "클립 추가", height: 198, insertView: addClipBottomSheetView)
    
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
        fetchClipData()
    }
}

// MARK: - Private Extension

private extension SelectClipViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        
        clipSelectCollectionView.do {
            $0.register(RemindSelectClipCollectionViewCell.self, forCellWithReuseIdentifier: RemindSelectClipCollectionViewCell.className)
            
            $0.register(SelectClipHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectClipHeaderView.className)
            
            $0.backgroundColor = .toasterBackground
        }
        
        completeButton.do {
            $0.makeRounded(radius: 12)
            $0.backgroundColor = .black850
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.titleLabel?.font = .suitBold(size: 16)
            $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(clipSelectCollectionView, completeButton)
    }
    
    func setupLayout() {
        clipSelectCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top).offset(-10)
        }
        
        completeButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.bottom.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setupDelegate() {
        clipSelectCollectionView.delegate = self
        clipSelectCollectionView.dataSource = self
        addClipBottomSheetView.addClipBottomSheetViewDelegate = self
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string("링크 저장"),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.close),
                                                                rightButtonAction: closeButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func closeButtonTapped() {
        showPopup(forMainText: "링크 저장을 취소하시겠어요?",
                  forSubText: "저장 중인 링크가 사라져요",
                  forLeftButtonTitle: "닫기",
                  forRightButtonTitle: "삭제",
                  forRightButtonHandler: rightButtonTapped)
    }
    
    func rightButtonTapped() {
        dismiss(animated: false)
        delegate?.cancleLinkButtonTapped()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        postSaveLink(url: linkURL, category: categoryID)
    }
}

// MARK: - UICollectionViewDelegate

extension SelectClipViewController: UICollectionViewDelegate { 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryID = selectedClip[indexPath.item].id
    }
}

// MARK: - UICollectionViewDataSource

extension SelectClipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return selectedClip.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemindSelectClipCollectionViewCell.className, for: indexPath) as? RemindSelectClipCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(forModel: selectedClip[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SelectClipHeaderView.className, for: indexPath) as? SelectClipHeaderView else { return UICollectionReusableView() }
            headerView.selectClipHeaderViewDelegate = self
            headerView.setupView()
            headerView.bindData(count: selectedClip.count)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    // Header 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 335, height: 68)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectClipViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.convertByWidthRatio(335), height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension SelectClipViewController: SelectClipHeaderViewlDelegate {
    func addClipCellTapped() {
        addClipBottom.modalPresentationStyle = .overFullScreen
        self.present(addClipBottom, animated: false)
    }
}

extension SelectClipViewController: AddClipBottomSheetViewDelegate {
    func dismissButtonTapped(text: PostAddCategoryRequestDTO) {
        postAddCategoryAPI(requestBody: text)
    }
    
    func callCheckAPI(text: String) {
        getCheckCategoryAPI(categoryTitle: text)
    }
    
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

// MARK: - Network
extension SelectClipViewController {
    // 임베드한 링크, 선택한 클립 id - POST
    func postSaveLink(url: String, category: Int?) {
            let request = PostSaveLinkRequestDTO(linkUrl: url,
                                                 categoryId: category)
            NetworkService.shared.toastService.postSaveLink(requestBody: request) { result in
                switch result {
                case .success:
                    self.delegate?.saveLinkButtonTapped()
                    self.navigationController?.popToRootViewController(animated: true)
                case .networkFail, .unAuthorized, .notFound:
                    self.changeViewController(viewController: LoginViewController())
                default:
                    return
                }
        }
    }
    
    // 클립 정보 - GET
    func fetchClipData() {
        NetworkService.shared.clipService.getAllCategory { result in
            switch result {
            case .success(let response):
                var clipDataList: [RemindClipModel] = [RemindClipModel(id: nil,
                                                                       title: "전체",
                                                                       clipCount: response?.data.toastNumberInEntire ?? 0)]
                response?.data.categories.forEach {
                    let clipData = RemindClipModel(id: $0.categoryId,
                                                   title: $0.categoryTitle,
                                                   clipCount: $0.toastNum)
                    clipDataList.append(clipData)
                }
                self.selectedClip = clipDataList
            case .networkFail, .unAuthorized, .notFound:
                self.changeViewController(viewController: LoginViewController())
            default: break
            }
        }
    }
    
    func postAddCategoryAPI(requestBody: PostAddCategoryRequestDTO) {
        NetworkService.shared.clipService.postAddCategory(requestBody: requestBody) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.addClipBottomSheetView.resetTextField()
                    self.addClipBottom.hideBottomSheet()
                    self.showToastMessage(width: 157, status: .check, message: "클립 생성 완료!")
                }
                self.fetchClipData()
            case .networkFail, .unAuthorized, .notFound:
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
                            self.addClipBottomSheetView.changeTextField(addButton: false, border: true, error: true, clearButton: true)
                            self.addClipBottomSheetView.setupMessage(message: "이미 같은 이름의 클립이 있어요")
                        } else {
                            self.minusHeightBottom()
                        }
                    }
                }
            case .networkFail, .unAuthorized, .notFound:
                self.changeViewController(viewController: LoginViewController())
            default: return
            }
        }
    }  
}

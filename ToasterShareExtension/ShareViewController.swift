//
//  Share2ViewController.swift
//  ToasterShareExtension
//
//  Created by ParkJunHyuk on 3/20/24.
//

import UIKit
import Social

import SnapKit
import Then

@objc(ShareViewController)
class ShareViewController: UIViewController {
    
    // MARK: - Properties
    private var urlString = ""
    private let viewModel = RemindSelectClipViewModel()
    private var categoryID: Int?
    private var selectedClip: RemindClipModel? {
        didSet {
            nextBottomButton.backgroundColor = .toasterBlack
        }
    }
    
    private var titleHeight: Int {
        return isUseShareExtension ? 64 : 0
    }
    
    private let appURL = "TOASTER://"
    private var isUseShareExtension = false
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let bottomSheetView = UIView()
    private var clipSelectCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let nextBottomButton = UIButton()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUrl()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupButton()
        setupRegisterCell()
        setupViewModel()
        fetchCheckTokenHealth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear View height: \(self.view.frame.size.height)")
        
        if isUseShareExtension {
            // 상단 Title 높이 + 데이터 개수 * cell 높이 + 하단 버튼 + SafeArea
            let calculateBottomSheetHeight = titleHeight + (viewModel.clipData.count) * 54 + 116
            
            let bottomSheetHeight = { () -> Int in
                // 화면에 보여줄 크키보다 Sheet 높이가 커질 경우 (데이터가 많을 경우)
                if Int(self.view.frame.height) < calculateBottomSheetHeight {
                    print("높이 초과")
                    self.clipSelectCollectionView.isScrollEnabled = true
                    return Int(self.view.frame.height)
                } else {
                    print("높이 이하")
                    return calculateBottomSheetHeight
                }
            }
            
            bottomSheetView.snp.remakeConstraints {
                $0.height.equalTo(bottomSheetHeight())
                $0.bottom.leading.trailing.equalToSuperview()
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

// MARK: - Private Extensions

private extension ShareViewController {
    func setupStyle() {
        view.backgroundColor = .clear
        
        titleLabel.do {
            $0.font = .suitBold(size: 18)
            $0.textColor = .toasterBlack
            $0.text = "클립을 선택해 주세요"
        }
        
        closeButton.do {
            $0.setImage(.icClose24, for: .normal)
            $0.isUserInteractionEnabled = true
        }
        
        bottomSheetView.do {
            $0.backgroundColor = .toasterBackground
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.makeRounded(radius: 20)
        }
        
        clipSelectCollectionView.do {
            $0.backgroundColor = .toasterBackground
            $0.makeRounded(radius: 12)
            $0.clipsToBounds = true
            $0.isScrollEnabled = false
            $0.showsVerticalScrollIndicator = false
        }
        
        nextBottomButton.do {
            $0.setTitle(StringLiterals.Button.next, for: .normal)
            $0.setTitleColor(.toasterWhite, for: .normal)
            $0.backgroundColor = .gray200
            $0.makeRounded(radius: 12)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(bottomSheetView)
        bottomSheetView.addSubviews(titleLabel, closeButton, clipSelectCollectionView, nextBottomButton)
    }
    
    func setupLayout() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        clipSelectCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(nextBottomButton.snp.top).inset(-20)
        }
        
        nextBottomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(62)
        }
    }
    
    func setupRegisterCell() {
        clipSelectCollectionView.register(RemindSelectClipCollectionViewCell.self, forCellWithReuseIdentifier: RemindSelectClipCollectionViewCell.className)
    }
    
    func setupDelegate() {
        clipSelectCollectionView.delegate = self
        clipSelectCollectionView.dataSource = self
    }
    
    func setupButton() {
        closeButton.addTarget(self, action: #selector(hideBottomSheetAction), for: .touchUpInside)
        nextBottomButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    func setupViewModel() {
        viewModel.setupDataChangeAction(changeAction: reloadCollectionView)
    }
    
    func reloadCollectionView() {
        clipSelectCollectionView.reloadData()
    }
    
    @objc func hideBottomSheetAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        postSaveLink(url: urlString, category: categoryID)
    }
    
    // 웹 사이트 URL 를 받아올 수 있는 메서드
    func getUrl() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProviders = item.attachments {
            itemProviders.forEach { itemProvider in
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url") { [weak self] (url, error) in
                        if let shareURL = url as? URL {
                            self?.urlString = shareURL.absoluteString
                        } else {
                            print("Error loading URL: \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
        }
    }
    
    func fetchCheckTokenHealth() {
        NetworkService.shared.authService.postTokenHealth(tokenType: .accessToken) { [weak self] result in
            switch result {
            case .success(let response):
                self?.isUseShareExtension = true
            case .unAuthorized, .networkFail:
                self?.isUseShareExtension = false
                self?.showAlert()
            default:
                self?.isUseShareExtension = false
                self?.showAlert()
            }
        }
    }
    
    func postSaveLink(url: String, category: Int?) {
        let request = PostSaveLinkRequestDTO(linkUrl: url,
                                             categoryId: category)
        NetworkService.shared.toastService.postSaveLink(requestBody: request) { [weak self] result in
            switch result {
            case .success:
                print("저장 성공")
                self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            case .networkFail, .unAuthorized, .notFound:
                print("저장 실패")
            case .badRequest, .serverErr:
                print("저장 실패")
            default:
                return
            }
        }
    }
}

// MARK: - Alert

private extension ShareViewController {
    func showAlert() {
        let alert = UIAlertController(title: "로그인이 필요한 서비스예요", message: "로그인 세션이 만료되었거나\n서비스 가입이 필요해요.\n앱으로 이동하시겠어요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in self.openMyApp() })
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: { _ in self.cancelButtonAction() })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func cancelButtonAction() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

// MARK: - URL Scheme ( 외부에서 앱 실행 )

private extension ShareViewController {
    
    func openMyApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURL) else { return }
            _ = self.openURL(url)
        })
    }
    
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}

// MARK: - UICollectionViewDelegate

extension ShareViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedClip = viewModel.clipData[indexPath.item]
        let selectRow = viewModel.clipData[indexPath.item].id
        categoryID = selectRow == 0 ? nil : selectRow
    }
}

// MARK: - UICollectionViewDataSource

extension ShareViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.clipData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemindSelectClipCollectionViewCell.className, for: indexPath) as? RemindSelectClipCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.configureCell(forModel: viewModel.clipData[indexPath.item], icon: .icAllClip24, isShareExtension: true)
        } else {
            cell.configureCell(forModel: viewModel.clipData[indexPath.item], icon: .icClip24Black, isShareExtension: true)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShareViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.convertByWidthRatio(335), height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

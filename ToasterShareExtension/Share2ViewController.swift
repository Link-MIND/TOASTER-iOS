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

@objc(Share2ViewController)
class Share2ViewController: UIViewController {

    // MARK: - Properties
    private var urlString = ""
    private let viewModel = RemindSelectClipViewModel()
    private var categoryID: Int?
    private var selectedClip: RemindClipModel? {
        didSet {
            nextBottomButton.backgroundColor = .toasterBlack
        }
    }
    private let titleHeight = 64
    var sharingData:NSExtensionContext!
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let bottomSheetView = UIView()
    private var clipSelectCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let nextBottomButton = UIButton()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .clear
        
        getUrl()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupButton()
        setupRegisterCell()
        setupViewModel()
//        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "로그인이 필요한 서비스예요", message: "로그인 세션이 만료되었거나\n서비스 가입이 필요해요.\n앱으로 이동하시겠어요?", preferredStyle: .alert)
     
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.direction == .down {
//            // ViewController를 내리는 동작 수행
//            self.hideExtensionWithCompletionHandler(completion: { _ in
//                self.sharingData?.completeRequest(returningItems: nil, completionHandler: nil)
//            })
//        }
//    }
//    
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//        print(translation.y)
//        if gesture.state == .ended {
//            
////            UIView.animate(withDuration: 0.3, animations: {
////                self.navigationController!.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
////            }, completion: nil)
//            
//            if translation.y > 0 {
//                // ViewController를 내리는 동작 수행
//                print(translation.y)
//                self.hideExtensionWithCompletionHandler(completion: { _ in
//                    self.sharingData?.completeRequest(returningItems: nil, completionHandler: nil)
//                })
//            }
//        }
//    }
//    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getUrl()
//        print("viewWillAppear View height: \(self.view.frame.size.height)")
//        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                self.view.transform = .identity
//            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear View height: \(self.view.frame.size.height)")
        
        let calculateBottomSheetHeight = titleHeight + (viewModel.clipData.count) * 54 + 116
        
        let bottomSheetHeight = { () -> Int in
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
        
        DispatchQueue.main.async { // curveEaseInOut
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
//                self.view.backgroundColor = .black900.withAlphaComponent(0.5)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")
    }
    
    deinit {
        print("Share2ViewController deinit")
    }
}

// MARK: - Private Extensions

private extension Share2ViewController {
    func setupStyle() {
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
        print("실행")
        clipSelectCollectionView.reloadData()
        
        let fullViewHeight = view.bounds.height
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
   
        print("전체 높이: ", self.view.frame.size.height)
        print("safeArea:", safeAreaHeight)
        print("디바이스 높이", view.getDeviceHeight())
        let calculateBottomSheetHeight = titleHeight + (viewModel.clipData.count) * 54 + 116
        print("바텀 시트 높이", calculateBottomSheetHeight)
        
        let calculateBottomSheetHeight1 = titleHeight + (viewModel.clipData.count) * 54 + 116

    }
    
    @objc func hideBottomSheetAction(_ sender: UIButton) {
        print("버튼 눌르기")

        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: { _ in
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
    }
    
    func hideExtensionWithCompletionHandler(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController!.view.transform = CGAffineTransform(translationX: 0, y: self.navigationController!.view.frame.size.height)
        }, completion: completion)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        postSaveLink(url: urlString, category: categoryID)
    }
    
    func getUrl() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first as? NSItemProvider,
            itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (url, error) in
                if let shareURL = url as? URL {
                   // do what you want to do with shareURL
                   print(shareURL.absoluteString)
                    self?.urlString = shareURL.absoluteString
               } else {
                   // handle error
                   print("Error loading URL: \(error?.localizedDescription ?? "")")
               }
            }
        }
    }
    
    func postSaveLink(url: String, category: Int?) {
        let request = PostSaveLinkRequestDTO(linkUrl: url,
                                             categoryId: category)
        NetworkService.shared.toastService.postSaveLink(requestBody: request) { result in
            switch result {
            case .success:
                print("저장 성공")
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { [weak self] (success) in
                                if success {
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self?.view.transform = CGAffineTransform(translationX: 0, y: self?.view.frame.height ?? 0.0)
                                    }, completion: nil)
        //                            self?.dismiss(animated: true, completion: nil) // Share Extension 닫기
                        }
                    })
                
            case .networkFail, .unAuthorized, .notFound:
                print("저장 실패")
//                        self.changeViewController(viewController: LoginViewController())
//                    self.navigationController?.showToastMessage(width: 200, status: .warning, message: "링크 저장에 실패했어요!")
            case .badRequest, .serverErr:
                print("저장 실패")
//                        self.navigationController?.popToRootViewController(animated: true)
//                        self.navigationController?.showToastMessage(width: 200, status: .warning, message: "링크 저장에 실패했어요!")
            default:
                return
            }
        }
    }
}

extension Share2ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedClip = viewModel.clipData[indexPath.item]
        categoryID = viewModel.clipData[indexPath.item].id
    }
}

// MARK: - UICollectionViewDelegate

extension Share2ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedClip = viewModel.clipData[indexPath.item]
        categoryID = viewModel.clipData[indexPath.item].id
    }
}

// MARK: - UICollectionViewDataSource

extension Share2ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("데이터 개수: ", viewModel.clipData.count)
        return viewModel.clipData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemindSelectClipCollectionViewCell.className, for: indexPath) as? RemindSelectClipCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(forModel: viewModel.clipData[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension Share2ViewController: UICollectionViewDelegateFlowLayout {
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
        return 0
    }
}

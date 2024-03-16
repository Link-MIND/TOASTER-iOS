//
//  ShareViewController.swift
//  ToasterShareExtension
//
//  Created by ParkJunHyuk on 3/13/24.
//

import UIKit
import Social

import SnapKit
import Then
@objc(ShareViewController)
class ShareViewController: UIViewController {
    
    // MARK: - Properties
    
    var clipList: ClipModel = ClipModel(allClipToastCount: 0, clips: []) {
        didSet {
            clipListCollectionView.reloadData()
        }
    }
    
    let racView = UIView()
    
    // MARK: - UI Components
    
    private let clipListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.preferredContentSize = CGSize(width: 320, height: 480)
        
//        self.navigationController?.view.bounds = CGRect(x: 0, y: 0, width: 320, height: 480)
//        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        view.backgroundColor = .black900.withAlphaComponent(0.5)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        didSelectPost()
        
//        let toasterBottomSheetViewController = ToasterBottomSheetViewController(bottomType: .white,
//                                                                                bottomTitle: "클립 이름 수정",
//                                                                                height: 198,
//                                                                                insertView: clipListCollectionView)
//                
//        present(toasterBottomSheetViewController, animated: true, completion: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        getAllCategoryAPI()
//    }
    
    func didSelectPost() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = item.attachments?.first as? NSItemProvider,
            itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let shareURL = url as? URL {
                   // do what you want to do with shareURL
                   print(shareURL.absoluteString)
               } else {
                   // handle error
                   print("Error loading URL: \(error?.localizedDescription ?? "")")
               }
                self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
            }
        }
    }
}

// MARK: - Private Extensions

private extension ShareViewController {
    func setupStyle() {
        clipListCollectionView.backgroundColor = .toasterBackground
        
        racView.do {
            $0.backgroundColor = .white
//            $0.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        }
    }
    
    func setupHierarchy() {
//        view.addSubviews(clispListCollectionView)
        view.addSubviews(racView)
    }
    
    func setupLayout() {
        racView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.horizontalEdges.bottom.equalToSuperview()
//            $0.width.equalTo(100)
//            $0.height.equalTo(100)
        }
//        clipListCollectionView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
    }
    
    func setupRegisterCell() {
        clipListCollectionView.register(ClipListCollectionViewCell.self, forCellWithReuseIdentifier: ClipListCollectionViewCell.className)
    }
    
    func getAllCategoryAPI() {
        NetworkService.shared.clipService.getAllCategory { [weak self] result in
            switch result {
            case .success(let response):
                let allClipToastCount = response?.data.toastNumberInEntire
                var clips = [AllClipModel]()
                response?.data.categories.forEach {
                    clips.append(AllClipModel(id: $0.categoryId,
                                              title: $0.categoryTitle,
                                              toastCount: $0.toastNum))
                }
                self?.clipList = ClipModel(allClipToastCount: allClipToastCount ?? 0,
                                           clips: clips)
            case .unAuthorized, .networkFail, .notFound:
                print("오류")
//                self?.unAuthorizedAction?()
            default: return
            }
        }
    }
}

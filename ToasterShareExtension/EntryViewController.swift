////
////  EntryViewController.swift
////  ToasterShareExtension
////
////  Created by ParkJunHyuk on 3/21/24.
////
//
//import UIKit
//
//import Social
//
//@objc(EntryViewController)
//class EntryViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var urlString = ""
//    private let titleHeight = 64
//    private let viewModel = RemindSelectClipViewModel()
//    private var height = 0
//    
//    // MARK: - Life Cycles
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        view.backgroundColor = .green
//        getUrl()
////        calculateHeight()
//        setupViewModel()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let shareViewController = Share2ViewController()
//        calculateHeight()
//        print("바텀 높이:", height)
//        shareViewController.bindData(viewModelData: viewModel.clipData, height: height)
//        shareViewController.sharingData = self.extensionContext
//        let nav = UINavigationController(rootViewController: shareViewController)
//        self.present(nav, animated: false)
//    }
//}
//
//private extension EntryViewController {
//    
//    func setupViewModel() {
//        viewModel.setupDataChangeAction(changeAction: calculateHeight)
//    }
//    
//    func calculateHeight() {
//        let fullViewHeight = view.bounds.height
//        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
//   
////        print("전체 높이: ", self.view.frame.size.height)
////        print("safeArea:", safeAreaHeight)
////        print("디바이스 높이", view.getDeviceHeight())
//        
//        self.height = titleHeight + (viewModel.clipData.count) * 54 + 116
////        print("바텀 시트 높이", height)
//    }
//    
//    func getUrl() {
//        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
//            let itemProvider = item.attachments?.first as? NSItemProvider,
//            itemProvider.hasItemConformingToTypeIdentifier("public.url") {
//            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (url, error) in
//                if let shareURL = url as? URL {
//                   // do what you want to do with shareURL
//                   print(shareURL.absoluteString)
//                    self?.urlString = shareURL.absoluteString
//               } else {
//                   // handle error
//                   print("Error loading URL: \(error?.localizedDescription ?? "")")
//               }
//            }
//        }
//    }
//}

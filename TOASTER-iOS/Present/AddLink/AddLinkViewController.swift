//
//  AddLinkViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

protocol SaveLinkButtonDelegate: AnyObject {
    func saveLinkButtonTapped()
    func cancleLinkButtonTapped()
}

protocol AddLinkViewControllerPopDelegate: AnyObject {
    func changeTabBarIndex()
}

final class AddLinkViewController: UIViewController {
    
    // MARK: - Properties
    
    private var linkSaveList: SaveLinkModel? {
        didSet {
            // homeView.collectionView.reloadData()
        }
    }
    
    private weak var delegate: AddLinkViewControllerPopDelegate?

    // MARK: - UI Properties
    
    private var addLinkView = AddLinkView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setAddLinkVew()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()

        navigationBarHidden(forHidden: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationBarHidden(forHidden: false)
    }
    
    // MARK: - set up Add Link View
    
    private func setAddLinkVew() {
        view.addSubview(addLinkView)
        
        addLinkView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addLinkView.nextBottomButton.addTarget(self, action: #selector(tappedNextBottomButton), for: .touchUpInside)
        addLinkView.nextTopButton.addTarget(self, action: #selector(tappedNextBottomButton), for: .touchUpInside)
    }
}

// MARK: - extension

extension AddLinkViewController {
    func setupDelegate(forDelegate: AddLinkViewControllerPopDelegate) {
        delegate = forDelegate
    }
}

// MARK: - Private extension

private extension AddLinkViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: false,
                                                                hasRightButton: true,
                                                                mainTitle: StringOrImageType.string("링크 저장"),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.close),
                                                                rightButtonAction: closeButtonTapped)
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func navigationBarHidden(forHidden: Bool) {
        tabBarController?.tabBar.isHidden = forHidden
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
        delegate?.changeTabBarIndex()
        navigationController?.popViewController(animated: false)
    }
    
    @objc func tappedNextBottomButton() {
        if (addLinkView.linkEmbedTextField.text?.count ?? 0) < 1 {
            addLinkView.emptyError()
        } else {
            postSaveLink()
            let selectClipViewController = SelectClipViewController()
            selectClipViewController.delegate = self
            self.navigationController?.pushViewController(selectClipViewController, animated: true)
        }
    }
    
}

extension AddLinkViewController: SaveLinkButtonDelegate {
    func saveLinkButtonTapped() {
        delegate?.changeTabBarIndex()
        navigationController?.showToastMessage(width: 157, status: .check, message: "링크 저장 완료!")
    }
    
    func cancleLinkButtonTapped() {
        delegate?.changeTabBarIndex()
    }
}

 // MARK: - Network

extension AddLinkViewController {
    func postSaveLink() {
        let request = PostSaveLinkRequestDTO(linkUrl: linkSaveList?.linkUrl ?? "",
                                             categoryId: linkSaveList?.categoryId)
        NetworkService.shared.toastService.postSaveLink(requestBody: request) { result in
            switch result {
            case .success:
                print(result)
            case .networkFail, .unAuthorized:
                self.changeViewController(viewController: LoginViewController())
            default:
                return
            }
        }
    }
    
}

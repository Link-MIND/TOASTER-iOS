//
//  ToasterBottomSheetViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/2/24.
//

import UIKit

import SnapKit
import Then

final class ToasterBottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    private var bottomHeight: CGFloat = 100
    private var keyboardHeight: CGFloat = 100
    
    // MARK: - UI Properties
    private var insertView = UIView()
    private let dimmedBackView = UIView()
    private let bottomSheetView = UIView()
    
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(bottomType: BottomType,
         bottomTitle: String,
         height: CGFloat,
         insertView: UIView) {
        super.init(nibName: nil, bundle: nil)
        
        self.bottomSheetView.backgroundColor = bottomType.color
        self.titleLabel.textAlignment = bottomType.alignment
        self.titleLabel.text = bottomTitle
        self.bottomHeight = height
        self.insertView = insertView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDismissAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
}

// MARK: - Networks

extension ToasterBottomSheetViewController {
    /// 바텀 시트 표출
    func showBottomSheet() {
        DispatchQueue.main.async {
            self.updateBottomSheetLayout()
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.dimmedBackView.backgroundColor = .black900.withAlphaComponent(0.5)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /// 바텀 시트 내리기
    func hideBottomSheet() {
        DispatchQueue.main.async {
            self.bottomSheetView.snp.remakeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.dimmedBackView.backgroundColor = .clear
                self.view.layoutIfNeeded()
                self.view.endEditing(true)
            }, completion: { _ in
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
            })
        }
    }
}

// MARK: - Private Extensions

private extension ToasterBottomSheetViewController {
    
    func setupStyle() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        bottomSheetView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.makeRounded(radius: 20)
        }
        
        titleLabel.do {
            $0.font = .suitBold(size: 18)
            $0.textColor = .toasterBlack
        }
        
        closeButton.do {
            $0.setImage(ImageLiterals.Common.close, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(dimmedBackView, bottomSheetView)
        bottomSheetView.addSubviews(titleLabel, closeButton, insertView)
    }
    
    func setupLayout() {
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottom)
        }
        
        insertView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupDismissAction() {
        // x 버튼 누를 때, 바텀시트를 내리는 Action Target
        closeButton.addTarget(self, action: #selector(hideBottomSheetAction), for: .touchUpInside)
        
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(hideBottomSheetAction))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 아래로 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideBottomSheetAction))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    func updateBottomSheetLayout() {
        bottomSheetView.snp.remakeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(self.view.frame.height - self.keyboardHeight - self.bottomHeight)
        }
    }
    
    @objc
    func hideBottomSheetAction() {
        hideBottomSheet()
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            updateBottomSheetLayout()
        }
    }
}

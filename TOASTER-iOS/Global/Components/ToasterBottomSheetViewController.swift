//
//  ToasterBottomSheetViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/2/24.
//

import UIKit

import SnapKit
import Then

enum BottomType {
    /// 토스터 메인 컬러 색상 버튼이 있는 바텀 -> 키보드가 딸려 있는 것이 default
    case orangeBottom
    
    /// 검정색 버튼이 있는 바텀 -> 키보드 사용 x, 버튼 간격이 존재
    case blackBottom
    
    /// 버튼을 사용하지 않는 바텀
    case defaultBottom
}

enum ColorType {
    case whiteColor, grayColor
    
    var color: UIColor {
        switch self {
        case .whiteColor:
            return .toasterWhite
        case .grayColor:
            return .gray50
        }
    }
}

final class ToasterBottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    private var bottomType: BottomType = .defaultBottom
    private var bottomHeight: CGFloat = 100
    
    // MARK: - UI Properties
    
    private let dimmedBackView = UIView()
    
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .toasterBackground
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.makeRounded(radius: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .suitBold(size: 18)
        $0.textColor = .toasterBlack
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(ImageLiterals.Common.close, for: .normal)
    }
    
    // MARK: - Life Cycle
    
    init(bottomStyle: BottomType,
         colorStyle: ColorType,
         bottomTitle: String,
         height: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        self.bottomType = bottomStyle
        self.bottomSheetView.backgroundColor = colorStyle.color
        self.titleLabel.text = bottomTitle
        self.bottomHeight = height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.bottomSheetView.snp.remakeConstraints {
                $0.bottom.leading.trailing.equalToSuperview()
                $0.top.lessThanOrEqualToSuperview().inset(self.view.frame.height-self.bottomHeight)
            }
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
                $0.top.equalTo(self.bottomSheetView.snp.bottom)
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.dimmedBackView.backgroundColor = .clear
                self.view.layoutIfNeeded()
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
    
    func setupHierarchy() {
        view.addSubviews(dimmedBackView, bottomSheetView)
        bottomSheetView.addSubviews(titleLabel, closeButton)
    }
    
    func setupLayout() {
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(view.frame.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
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
    
    @objc
    func hideBottomSheetAction() {
        hideBottomSheet()
    }
}

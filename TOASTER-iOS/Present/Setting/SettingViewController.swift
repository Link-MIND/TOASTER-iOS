//
//  SettingViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/14/24.
//

import UIKit

import SnapKit
import Then

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let settingList = ["알림 설정", "1:1 문의", "이용약관", "로그아웃"]
    private var isToggle: Bool = true {
        didSet {
            setupWarningView()
        }
    }
    
    // MARK: - UI Properties
    
    private let alertWarningView = UIView()
    private let warningStackView = UIStackView()
    private let warningImage = UIImageView()
    private let warningLabel = UILabel()
    private let settingTableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

// MARK: - Private Extensions

private extension SettingViewController {
    func setupStyle() {
        view.backgroundColor = .toasterBackground
        
        alertWarningView.do {
            $0.backgroundColor = .gray50
            $0.makeRounded(radius: 12)
        }
        
        warningStackView.do {
            $0.spacing = 5
        }
        
        warningImage.do {
            $0.image = ImageLiterals.Common.alert
            $0.contentMode = .scaleAspectFit
        }
        
        warningLabel.do {
            $0.text = "알림 설정을 끄면 타이머 기능을 이용할 수 없어요"
            $0.font = .suitBold(size: 12)
            $0.textColor = .gray400
        }
        
        settingTableView.do {
            $0.backgroundColor = .toasterBackground
            $0.isScrollEnabled = false
            $0.separatorStyle = .none
            $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.className)
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(alertWarningView, settingTableView)
        alertWarningView.addSubview(warningStackView)
        warningStackView.addArrangedSubviews(warningImage, warningLabel)
    }
    
    func setupLayout() {
        alertWarningView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(42)
        }
        
        warningStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        warningImage.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        warningLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
        }
        
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(alertWarningView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        let type: ToasterNavigationType = ToasterNavigationType(hasBackButton: true,
                                                                hasRightButton: false,
                                                                mainTitle: StringOrImageType.string("설정"),
                                                                rightButton: StringOrImageType.image(ImageLiterals.Common.setting),
                                                                rightButtonAction: {})
        
        if let navigationController = navigationController as? ToasterNavigationController {
            navigationController.setupNavigationBar(forType: type)
        }
    }
    
    func setupWarningView() {
        if isToggle {
            settingTableView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        } else {
            settingTableView.snp.remakeConstraints {
                $0.top.equalTo(alertWarningView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    func fetchSignOut() {
        NetworkService.shared.authService.postLogout { [weak self] result in
            switch result {
            case .success:
                let result = KeyChainService.deleteTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
                
                if result.access && result.refresh {
                    self?.changeViewController(viewController: LoginViewController())
                }
            case .notFound, .networkFail:
                print("🍞⛔️로그아웃 실패⛔️🍞")
            default:
                print("🍞⛔️로그아웃 실패⛔️🍞")
            }
        }
    }
    
    func deleteAccount() {
        NetworkService.shared.authService.deleteWithdraw { [weak self] result in
            switch result {
            case .success:
                let result = KeyChainService.deleteTokens(accessKey: Config.accessTokenKey, refreshKey: Config.refreshTokenKey)
                
                if result.access && result.refresh {
                    self?.changeViewController(viewController: LoginViewController())
                }
            case .notFound, .unProcessable, .networkFail:
                print("🍞⛔️회원탈퇴 실패⛔️🍞")
            default:
                print("🍞⛔️회원탈퇴 실패⛔️🍞")
            }
        }
    }
}

// MARK: - TableView Delegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 4))
        sectionHeaderView.backgroundColor = .gray50
        if section != 0 { return sectionHeaderView }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                // TODO: - 문의하기 기능 여기에다 붙입시다
                print("문의하기 붙여")
            case 2:
                let urlString = "https://www.notion.so/db429c114629431f8301a969ed028e37"
                
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            case 3:
                fetchSignOut()
            default:
                return
            }
        } else if indexPath.section == 2 {
            deleteAccount()
        }
    }
}

// MARK: - TableView DataSource

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.className, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            // TODO: - 사용자 유저 이름 불러오는 것으로 수정 필요
            cell.configureCell(name: "홍길동", sectionNumber: indexPath.section)
        case 1:
            cell.configureCell(name: settingList[indexPath.row], sectionNumber: indexPath.section)
            if indexPath.row == 0 {
                cell.showSwitch()
                cell.setSwitchValueChangedHandler { isOn in
                    self.isToggle = isOn
                    // TODO: - 토글 상태에 따른 알림 설정 분기처리는 여기에서 하세요
                }
            }
        default:
            cell.configureCell(name: "탈퇴하기", sectionNumber: indexPath.section)
        }
        return cell
    }
}

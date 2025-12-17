//
//  LoginViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    // MARK: - View Controllable

    var onLoginCompleted: (() -> Void)?
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel!
    private var cancelBag = CancelBag()
    private var currentIndex = 0
    
    // MARK: - UI Properties
    
    private let kakaoSocialLoginButtonView = SocialLoginButtonView(type: .kakao)
    private let appleSocialLoginButtonView = SocialLoginButtonView(type: .apple)
    private let socialLoginButtonStackView = UIStackView()
    private let onboardingPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    private let customPageIndicatorView = CustomPageIndicatorView()
    
    // MARK: - Life Cycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModels()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        selectedViewControllerSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
}

// MARK: - Private Extensions

private extension LoginViewController {
    func bindViewModels() {
        let input = LoginViewModel.Input(
            kakaoLoginButtonTapped: kakaoSocialLoginButtonView.tapPublisher(),
            appleLoginButtonTapped: appleSocialLoginButtonView.tapPublisher()
        )
        
        let output = viewModel.transform(input, cancelBag: cancelBag)
        
        output.loginSucceeded
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.onLoginCompleted?()
            }.store(in: cancelBag)
        
        output.loginFailed
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.showToastMessage(width: 220, status: .warning, message: error)
            }.store(in: cancelBag)
    }
    
    func setupStyle() {
        view.backgroundColor = .gray50

        socialLoginButtonStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
    }
    
    func setupHierarchy() {
        addChild(onboardingPageViewController)
        view.addSubviews(onboardingPageViewController.view, customPageIndicatorView, socialLoginButtonStackView)
        socialLoginButtonStackView.addArrangedSubviews(appleSocialLoginButtonView, kakaoSocialLoginButtonView)
    }

    func setupLayout() {
        onboardingPageViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(customPageIndicatorView.snp.top)
        }
        
        customPageIndicatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(socialLoginButtonStackView.snp.top).inset(view.convertByHeightRatio(-52))
            $0.height.equalTo(8)
        }
          
        socialLoginButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(view.convertByHeightRatio(26))
            $0.height.equalTo(136) // Button height(62 * 2) + StackView Spacing(12)
        }
        
        onboardingPageViewController.didMove(toParent: self)
    }
    
    private func setupDelegate() {
        onboardingPageViewController.dataSource = self
        onboardingPageViewController.delegate = self
    }
    
    func createOnboardingViewController(index: Int) -> OnboardingViewController? {
        guard index >= 0, index < OnboardingType.allCases.count else { return nil }
        let onboardType = OnboardingType.allCases[index]
        return OnboardingViewController(onboardType: onboardType)
    }
}

// MARK: - UIPageViewController Delegate

extension LoginViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // 이전 페이지를 가져오는 메서드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController, let currentIndex = OnboardingType.allCases.firstIndex(of: currentVC.onboardType), currentIndex > 0 else { return nil }

        let newIndex = currentIndex - 1
        return createOnboardingViewController(index: newIndex)
    }
    
    // 다음 페이지를 가져오는 메서드
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingViewController, let currentIndex = OnboardingType.allCases.firstIndex(of: currentVC.onboardType), currentIndex < OnboardingType.allCases.count - 1  else { return nil }
                
        let newIndex = currentIndex + 1
        return createOnboardingViewController(index: newIndex)
    }
    
    // 페이지 전환 애니메이션이 완료되었을 때 호출되는 메서드
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC = pageViewController.viewControllers?.first as? OnboardingViewController, let currentIndex = OnboardingType.allCases.firstIndex(of: currentVC.onboardType) else {
            return
        }
        self.currentIndex = currentIndex
        customPageIndicatorView.changeCurrentPageIndex(index: currentIndex)
    }
    
    // 초기 화면을 설정하는 메서드
    func selectedViewControllerSetting() {
        if let selectViewController = createOnboardingViewController(index: 0) {
            onboardingPageViewController.setViewControllers([selectViewController], direction: .forward, animated: false)
        }
    }
}

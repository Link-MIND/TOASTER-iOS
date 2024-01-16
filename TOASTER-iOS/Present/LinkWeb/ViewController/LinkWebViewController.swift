//
//  LinkWebViewController.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/11/24.
//

import UIKit
import WebKit

import SnapKit
import Then

final class LinkWebViewController: UIViewController {
    
    // MARK: - Properties
    
    private var canGoBack: Bool = false {
        didSet {
            backButton.isEnabled = canGoBack
            backButton.tintColor = canGoBack ? .gray700 : .gray150
        }
    }
    
    private var canGoForward: Bool = false {
        didSet {
            forwardButton.isEnabled = canGoForward
            forwardButton.tintColor = canGoForward ? .gray700 : .gray150
        }
    }
    
    private var isRead: Bool = false {
        didSet {
            readLinkCheckButton.tintColor = isRead ? .gray700 : .gray150
        }
    }
    private var toastId: Int = 0
    
    // MARK: - UI Properties
    
    private let navigationView = LinkWebNavigationView()
    private let progressView = UIProgressView()
    private let webView = WKWebView()
    private let toolBar = UIToolbar()
    
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private lazy var backButton = UIBarButtonItem(image: ImageLiterals.Web.backArrow, style: .plain, target: self, action: #selector(goBackInWeb))
    private lazy var forwardButton = UIBarButtonItem(image: ImageLiterals.Web.forwardArrow, style: .plain, target: self, action: #selector(goForwardInWeb))
    private lazy var readLinkCheckButton = UIBarButtonItem(image: ImageLiterals.Web.document, style: .plain, target: self, action: #selector(checkReadInWeb))
    private lazy var safariButton = UIBarButtonItem(image: ImageLiterals.Web.safari, style: .plain, target: self, action: #selector(openInSafari))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupNavigationBarAction()
        setupSwipeGesture()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}

// MARK: - Extensions

extension LinkWebViewController {
    func setupDataBind(linkURL: String, isRead: Bool, id: Int) {
        if let url = URL(string: linkURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        self.isRead = isRead
        self.toastId = id
    }
    
    /// KVO를 사용하여 estimatedProgress가 변경될 때 호출되는 메서드
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if let newProgress = change?[.newKey] as? NSNumber {
                let progress = Float(truncating: newProgress)
                progressView.progress = progress
            }
        }
    }
}

// MARK: - Private Extensions

private extension LinkWebViewController {
    func setupStyle() {
        view.bringSubviewToFront(progressView)
        view.backgroundColor = .toasterWhite
        hideNavigationBar()
        
        progressView.do {
            $0.tintColor = .toasterPrimary
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        webView.do {
            $0.navigationDelegate = self
            $0.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }
        
        toolBar.do {
            $0.backgroundColor = .toasterWhite
            $0.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
            $0.setShadowImage(UIImage(), forToolbarPosition: .bottom)
            $0.setItems([backButton, flexibleSpace, forwardButton, flexibleSpace, readLinkCheckButton, flexibleSpace, safariButton], animated: false)
        }
        
        [backButton, forwardButton, safariButton].forEach {
            $0.tintColor = .gray700
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationView, progressView, webView, toolBar)
    }
    
    func setupLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
        
        toolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
    }
    
    func setupNavigationBarAction() {
        /// 네비게이션바 뒤로가기 버튼 클릭 액션 클로저
        navigationView.popButtonTapped {
            self.navigationController?.popViewController(animated: true)
            self.showNavigationBar()
        }
        
        /// 네비게이션바 새로고침 버튼 클릭 액션 클로저
        navigationView.reloadButtonTapped {
            self.webView.reload()
        }
    }
    
    func setupSwipeGesture() {
        let swipeRecognizer = UISwipeGestureRecognizer().then {
            $0.addTarget(self, action: #selector(swipeAction))
            $0.direction = .right
        }
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            navigationController?.popViewController(animated: true)
            self.showNavigationBar()
        }
    }
    
    /// 툴바 뒤로가기 버튼 클릭 시
    @objc func goBackInWeb() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    /// 툴바 앞으로가기 버튼 클릭 시
    @objc func goForwardInWeb() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    /// 툴바 링크 확인 완료 버튼 클릭 시
    @objc func checkReadInWeb() {
        patchOpenLinkAPI(requestBody: PatchOpenLink(toastId: toastId, isRead: isRead))
    }
    
    /// 툴바 사파리 버튼 클릭 시
    @objc func openInSafari() {
        if let url = webView.url {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - WKNavigationDelegate Extensions

extension LinkWebViewController: WKNavigationDelegate {
    /// 현재 웹 페이지 링크를 받아오는 함수
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            navigationView.setupLinkAddress(link: url)
        }
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
    }
    
    /// 웹 페이지 로딩이 완료되었을 때 호출
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    /// 웹 페이지 로딩이 시작할 때 호출
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
}

// MARK: - Network

extension LinkWebViewController {
    func patchOpenLinkAPI(requestBody: PatchOpenLink) {
        NetworkService.shared.toastService.patchOpenLink(requestBody: requestBody) { result in
            switch result {
            case .success(let response):
                if !self.isRead {
                    self.showToastMessage(width: 152, status: .check, message: "링크 확인 완료")
                } else {
                    self.showToastMessage(width: 152, status: .check, message: "링크 열람 취소")
                }
                self.isRead = !self.isRead
            default: return
            }
        }
    }
}

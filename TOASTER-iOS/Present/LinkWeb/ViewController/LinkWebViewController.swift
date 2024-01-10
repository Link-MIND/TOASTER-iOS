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
    
    // MARK: - UI Properties
    
    private let navigationView = LinkWebNavigationView()
    private let webView = WKWebView()
    private let toolBar = UIToolbar()
    
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    private let backButton = UIBarButtonItem(image: ImageLiterals.Web.backArrow, style: .plain, target: LinkWebViewController.self, action: #selector(goBackInWeb))
    private let forwardButton = UIBarButtonItem(image: ImageLiterals.Web.forwardArrow, style: .plain, target: LinkWebViewController.self, action: #selector(goForwardInWeb))
    private let readLinkCheckButton = UIBarButtonItem(image: ImageLiterals.Web.document, style: .plain, target: LinkWebViewController.self, action: #selector(checkReadInWeb))
    private let safariButton = UIBarButtonItem(image: ImageLiterals.Web.safari, style: .plain, target: LinkWebViewController.self, action: #selector(openInSafari))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupURL()
    }
}

// MARK: - Private Extensions

private extension LinkWebViewController {
    func setupStyle() {
        view.backgroundColor = .toasterWhite
        hideNavigationBar()
        
        webView.do {
            $0.navigationDelegate = self
        }
        
        toolBar.do {
            $0.backgroundColor = .toasterWhite
            $0.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
            $0.setShadowImage(UIImage(), forToolbarPosition: .bottom)
            $0.setItems([backButton, flexibleSpace, forwardButton, flexibleSpace, readLinkCheckButton, flexibleSpace, safariButton], animated: false)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(navigationView, webView, toolBar)
    }
    
    func setupLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        webView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(toolBar.snp.top)
        }
        
        toolBar.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
    }
    
    func setupURL() {
        if let url = URL(string: "https://www.naver.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @objc func goBackInWeb() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func goForwardInWeb() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func checkReadInWeb() {
        
    }
    
    @objc func openInSafari() {
        if let url = webView.url {
            UIApplication.shared.open(url)
        }
    }
}

extension LinkWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString {
            navigationView.setupLinkAddress(link: url)
        }
    }
}

//
//  UIViewController+.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/29/23.
//

import UIKit

extension UIViewController {
    
    /// 네비게이션바를 숨기는 메서드
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// 숨긴 네비게이션 바를 보이게 하는 메서드
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    /// 화면밖 터치시 키보드를 내려 주는 메서드
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

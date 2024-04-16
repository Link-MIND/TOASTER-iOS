//
//  UpdateAlertManager.swift
//  TOASTER-iOS
//
//  Created by 민 on 4/16/24.
//

import UIKit

final class UpdateAlertManager {
    
    /// Alert 표출 함수
    func showUpdateAlert(type: UpdateAlertType,
                         on viewController: UIViewController) {
        let alertViewController = UIAlertController(title: type.title,
                                                    message: type.description,
                                                    preferredStyle: .alert)
        if type != .ForceUpdate {
            let laterAction = UIAlertAction(title: "다음에", style: .default)
            alertViewController.addAction(laterAction)
        }
        
        let updateAction = UIAlertAction(title: "업데이트",
                                         style: .default) {_ in
            if let url = URL(
                string: "itms-apps://itunes.apple.com/app/6476194200"),
               UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        alertViewController.addAction(updateAction)
        
        viewController.present(alertViewController, animated: true)
    }
}

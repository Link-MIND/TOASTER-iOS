//
//  UpdateAlertManager.swift
//  TOASTER-iOS
//
//  Created by 민 on 4/16/24.
//

import UIKit

final class UpdateAlertManager {
    private let appId = "6476194200"
    
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
        
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            if let url = URL(
                string: "itms-apps://itunes.apple.com/app/\(self.appId)"),
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
    
    /// iTunes API를 사용하여 앱스토어의 현재 앱 버전 불러오기
    func checkAppStoreVersion() async -> String {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appId)&country=kr") else { return "" }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let appStoreVersion = results[0]["version"] as? String { return appStoreVersion }
        } catch {
            print("앱스토어 버전을 가져오지 못했습니다😡")
        }
        
        return ""
    }
    
    /// 앱스토어 버전과 현재 버전 비교하기
    func checkUpdateAlertNeeded() async -> UpdateAlertType? {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let appStoreVersion = await checkAppStoreVersion()
        
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let appStoreVersionArray = appStoreVersion.split(separator: ".").map { $0 }

        if (currentVersionArray[0] < appStoreVersionArray[0]) {
            return .ForceUpdate
        } else if (currentVersionArray[0] == appStoreVersionArray[0])
                    && (currentVersionArray[1] < appStoreVersionArray[1]) {
            return .NoticeFeatUpdate
        } else if (currentVersionArray[0] == appStoreVersionArray[0])
                    && (currentVersionArray[1] == appStoreVersionArray[1])
                    && (currentVersionArray[2] < appStoreVersionArray[2]) {
            return .NoticeUpdate
        } else {
            return nil
        }
    }
}

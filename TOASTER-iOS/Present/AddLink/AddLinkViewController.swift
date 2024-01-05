//
//  AddLinkViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class AddLinkViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private var addLinkView: AddLinkView?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddLinkVew()
        hideKeyboard()
    }
    
    // MARK: - set up Add Link View
    
    private func setAddLinkVew() {
        addLinkView = AddLinkView(frame: view.bounds)
        if let resultView = addLinkView {
            view.addSubview(resultView)
            resultView.setView()
        }
    }
}

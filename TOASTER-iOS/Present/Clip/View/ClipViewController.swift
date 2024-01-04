//
//  ClipViewController.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 12/30/23.
//

import UIKit

import SnapKit
import Then

final class ClipViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let clipListTableView = UITableView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        // view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
}

// MARK: - Networks

extension ClipViewController {
    func fetchMain() {
        <#code#>
    }
}

// MARK: - Private Extensions

private extension ClipViewController {
    func setupStyle() {
        <#code#>
    }
    
    func setupHierarchy() {
        <#code#>
    }
    
    func setupLayout() {
        <#code#>
    }
    
    func setupDelegate() {
        <#code#>
    }
    
}


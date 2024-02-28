//
//  AddLinkViewModel.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 2024/02/27.
//

import Foundation

final class AddLinkViewModel {
    
    // MARK: - Properties
    
    typealias DataChangeAction = (Bool) -> Void
    private var dataChangeAction: DataChangeAction?
    private var dataEmptyAction: DataChangeAction?
    
    typealias NormalChangeAction = () -> Void
    private var unAuthorizedAction: NormalChangeAction?
    private var textFieldEditAction: NormalChangeAction?
    
    // MARK: - Data
    
    private var linkSaveList: SaveLinkModel?
    
}


// MARK: - extension

extension AddLinkViewModel {
    
    
}

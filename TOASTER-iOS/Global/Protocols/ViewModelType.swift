//
//  ViewModelType.swift
//  TOASTER-iOS
//
//  Created by Gahyun Kim on 9/27/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

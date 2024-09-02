//
//  ViewModelType.swift
//  TOASTER-iOS
//
//  Created by 민 on 9/2/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

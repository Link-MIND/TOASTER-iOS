//
//  CoordinatorFinishOutput.swift
//  TOASTER-iOS
//
//  Created by 민 on 1/10/25.
//

import Foundation

@MainActor
protocol CoordinatorFinishOutput {
    var onFinish: (() -> Void)? { get set }
}

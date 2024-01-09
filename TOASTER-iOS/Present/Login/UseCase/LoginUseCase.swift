//
//  LoginUseCase.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/6/24.
//

import Foundation

struct LoginUseCase {
    let adapter: AuthenticationAdapterProtocol
    
    var adapterType: String {
        return adapter.adapterType
    }
    
    init(adapter: AuthenticationAdapterProtocol) {
        self.adapter = adapter
    }
    
    func login() async throws -> SocialLoginTokenModel {
        return try await adapter.login()
    }
}

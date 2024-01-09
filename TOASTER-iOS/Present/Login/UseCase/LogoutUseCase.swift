//
//  LogoutUseCase.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/7/24.
//

import Foundation

struct LogoutUseCase {
    let adapter: AuthenticationAdapterProtocol
    
    var adapterType: String {
        return adapter.adapterType
    }
    
    init(adapter: AuthenticationAdapterProtocol) {
        self.adapter = adapter
    }
    
    func logout() async throws -> Bool {
        return try await adapter.logout()
    }
}

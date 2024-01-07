//
//  AuthenticationAdapterProtocol.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/4/24.
//

import Foundation

protocol AuthenticationAdapterProtocol {
    var adapterType: String { get }
    
    func login() async throws -> SocialLoginTokenModel
    
    func logout() async throws -> Bool
}

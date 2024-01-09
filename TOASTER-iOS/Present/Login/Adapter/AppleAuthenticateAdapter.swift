//
//  AppleAuthenticateAdapter.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/9/24.
//

import Foundation

import AuthenticationServices

final class AppleAuthenticateAdapter: NSObject, AuthenticationAdapterProtocol {
    var adapterType: String {
        return "Apple Adapter"
    }
    
    private var authorizationContinuation: CheckedContinuation<SocialLoginTokenModel, Error>?
    
    func login() async throws -> SocialLoginTokenModel {
        return try await withCheckedThrowingContinuation { continuation in
            self.authorizationContinuation = continuation
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName]
           
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    func logout() async throws -> Bool {
        print("로그아웃")
        return true
    }
}

extension AppleAuthenticateAdapter: ASAuthorizationControllerDelegate {
    /// Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokenString = String(data: idToken, encoding: .utf8)
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: tokenString))")
            
            authorizationContinuation?.resume(returning: SocialLoginTokenModel(accessToken: nil, refreshToken: nil, identityToken: tokenString))
            authorizationContinuation = nil
            
        default:
            break
        }
    }
    
    /// Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        authorizationContinuation?.resume(throwing: error)
        authorizationContinuation = nil
    }
}

extension AppleAuthenticateAdapter: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // 필요한 window 반환. 대부분의 경우 현재 앱의 메인 window를 반환합니다.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first ?? UIWindow()
        }
        
        return UIWindow()
    }
}

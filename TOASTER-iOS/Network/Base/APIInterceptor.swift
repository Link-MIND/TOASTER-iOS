//
//  AuthInterceptor.swift
//  TOASTER-iOS
//
//  Created by ParkJunHyuk on 1/15/24.
//

import Foundation

import Alamofire
import UIKit

final class APIInterceptor: RequestInterceptor {
    
    /// 리프레쉬 토큰을 통해 액세스 토큰을 재발급 받았는지 확인하는 프로퍼티
    /// 재발급을 받고 다시 기존 API 를 호출해야하기 때문에 Requset 의 Header 를 변경해야 한다.
    /// 해당 프로퍼티가 true 일 경우 기존의 Requset 의 Header 를 변경
    /// 재발급을 받은 적이 없는 false 의 경우 TargetType 을 통해 Header 를 설정한 Requset 를 기본으로 사용
    private var isTokenRefreshed = false

    static let shared = APIInterceptor()

    private init() {}

    /// 서버로 보내기전에 api를 가로채서 전처리를 한 뒤 서버로 보내는 역할
    /// 즉, Request가 전송되기 전에 원하는 추가적인 작업을 수행할 수 있도록 하는 함수
    /// Header 설정을 해당 함수에서 할 수 있지만 BaseTargetType 에 미리 구현이 되어있어 넣지 않음
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("adapt 진입")
        
        if isTokenRefreshed {
            print("토큰 재발급 후 URLRequset 변경")
            var modifiedRequest = urlRequest
            modifiedRequest.setValue(KeyChainService.loadAccessToken(key: Config.accessTokenKey), forHTTPHeaderField: "accessToken")
            
            isTokenRefreshed = false
            
            completion(.success(modifiedRequest))
        } else {
            completion(.success(urlRequest))
        }
    }

    /// Request가 전송되고 받은 Response에 따라 수행할 작업을 지정
    /// 즉, 통신이 실패했을 때 retry 하는 기능을 제공
    /// 리프레쉬 토큰 재발급 API 를 호출하게 되는데 해당 API 도 401 을 반환할 수 있어 계속 adapt, retry 가 무한으로 반복될 가능성이 있음
    /// 리프레쉬 토큰 재발급 API 의 반복 호출을 막기 위해 guard let 을 통해 해당 path ( URL ) 에서 token 이라는 String 이 존재한다면 정지
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, let pathComponents =
                request.request?.url?.pathComponents,
                !pathComponents.contains("token")
        else {
            completion(.doNotRetryWithError(error))
            return
        }

        print("retry 코드:", response.statusCode)
        // 토큰 갱신 API 호출
        NetworkService.shared.authService.postRefreshToken { [weak self] result in
            switch result {
            case .success(let result):
                guard let serverAccessToken = result?.data.accessToken, let serverRefreshToken = result?.data.refreshToken 
                else {
                    completion(.doNotRetry)
                    return
                }
                
                let keyChainResult = KeyChainService.saveTokens(accessKey: serverAccessToken, refreshKey: serverRefreshToken)
                
                if keyChainResult.accessResult == true && keyChainResult.refreshResult == true {
                    self?.isTokenRefreshed = true
                    
                    guard var urlRequest = request.request
                    else {
                        completion(.doNotRetry)
                        return
                    }
                    
                    completion(.retry)
                    
                } else {
                    completion(.doNotRetry)
                }
            case .unAuthorized:
                completion(.doNotRetry)
            case .decodeErr, .networkFail:
                completion(.doNotRetry)
            default:
                completion(.doNotRetry)
            }
        }
    }
}

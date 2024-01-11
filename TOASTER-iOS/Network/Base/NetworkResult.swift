//
//  NetworkResult.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

enum NetworkResult<T> {
    
    case success(T?)
    
    case networkFail        // 네트워크 연결 실패했을 때
    case decodeErr          // 데이터는 받아왔으나 DTO 형식으로 decode가 되지 않을 때
    
    case badRequest         // BAD REQUEST EXCEPTION (400)
    case unAuthorized       // UNAUTHORIZED EXCEPTION (401)
    case notFound           // NOT FOUND (404)
    case unProcessable      // UNPROCESSABLE_ENTITY (422)
    case serverErr          // INTERNAL_SERVER_ERROR (500번대)
    
    var stateDescription: String? {
        switch self {
        case .success(_): return "SUCCESS"

        case .networkFail: return "NETWORK FAIL"
        case .decodeErr: return "DECODED_ERROR"
            
        case .badRequest: return "BAD REQUEST EXCEPTION"
        case .unAuthorized: return "UNAUTHORIZED EXCEPTION"
        case .notFound: return "NOT FOUND"
        case .unProcessable: return "UNPROCESSABLE ENTITY"
        case .serverErr: return "INTERNAL SERVER_ERROR"
        }
    }
}

//
//  NetworkError.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

enum NetworkError: Int, Error {
    
    case networkFail              // 네트워크 연결 실패했을 때
    case decodeErr                // 데이터는 받아왔으나 DTO 형식으로 decode가 되지 않을 때
    
    case badRequest = 400         // BAD REQUEST EXCEPTION (400)
    case unAuthorized = 401       // UNAUTHORIZED EXCEPTION (401)
    case notFound = 404           // NOT FOUND (404)
    case unProcessable = 422      // UNPROCESSABLE_ENTITY (422)
    case serverErr = 500          // INTERNAL_SERVER_ERROR (500번대)
    
    var errorDescription: String {
        switch self {
        case .badRequest: return "BAD REQUEST EXCEPTION"
        case .unAuthorized: return "UNAUTHORIZED EXCEPTION"
        case .notFound: return "NOT FOUND"
        case .unProcessable: return "UNPROCESSABLE_ENTITY"
        case .serverErr: return "INTERNAL_SERVER_ERROR"
        case .networkFail: return "NETWORK_FAIL"
        case .decodeErr: return "DECODED_ERROR"
        }
    }
}

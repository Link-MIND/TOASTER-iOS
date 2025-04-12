//
//  BaseAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Combine
import Foundation

import Moya

class BaseAPIService<Target: TargetType> {
        
    /// 200 받았을 때 decoding 할 데이터가 있는 경우 (대부분의 GET)
    func requestWithCombine<T: Decodable>(
        provider: MoyaProvider<Target>,
        target: Target,
        responseType: T.Type
    ) -> AnyPublisher<T, ToasterError> {
        return Future { promise in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    let statusCode = response.statusCode
                    let data = response.data
                    
                    switch statusCode {
                    case 200, 201, 204:
                        if let decodedData = try? decoder.decode(T.self, from: data) {
                            return promise(.success(decodedData))
                        } else { return promise(.failure(.decodeErr)) }
                    case 400: return promise(.failure(.badRequest))
                    case 401: return promise(.failure(.unAuthorized))
                    case 404: return promise(.failure(.notFound))
                    case 422: return promise(.failure(.unProcessable))
                    case 500: return promise(.failure(.serverErr))
                    default: return promise(.failure(.networkFail))
                    }
                case .failure:
                    promise(.failure(.networkFail))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// 200 받았을 때 decoding 할 데이터가 없는 경우 (대부분의 PATCH, PUT, DELETE)
    func requestWithoutDecodeWithCombine(
        provider: MoyaProvider<Target>,
        target: Target
    ) -> AnyPublisher<NoneDataResponseDTO?, ToasterError> {
        return Future { promise in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    
                    switch statusCode {
                    case 200, 201, 204: return promise(.success(nil))
                    case 400: return promise(.failure(.badRequest))
                    case 401: return promise(.failure(.unAuthorized))
                    case 404: return promise(.failure(.notFound))
                    case 422: return promise(.failure(.unProcessable))
                    case 500: return promise(.failure(.serverErr))
                    default: return promise(.failure(.networkFail))
                    }
                case .failure:
                    promise(.failure(.networkFail))
                }
            }
        }.eraseToAnyPublisher()
    }
}

//
//  BaseAPIService.swift
//  TOASTER-iOS
//
//  Created by 김다예 on 1/12/24.
//

import Foundation

class BaseAPIService {
    
    let successCode: Int = 200
    
    /// API를 통해 받아온 Data를 T Type 형태로 Decode하는 함수
    func fetchDecodeData<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(responseType, from: data){
            return decodedData
        } else { return nil }
    }
}

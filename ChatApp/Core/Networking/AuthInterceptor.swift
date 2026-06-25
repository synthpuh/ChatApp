//
//  AuthInterceptor.swift
//  ChatApp
//
//  Created by Olga on 14.03.2026.
//

import Alamofire
import Foundation

final class AuthInterceptor: RequestInterceptor {
    
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func adapt(_ urlRequest: URLRequest,
               using state: RequestAdapterState,
               completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        
        var request = urlRequest
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
}

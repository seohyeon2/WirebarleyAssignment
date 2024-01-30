//
//  CurrencylayerURLRequestBuilder.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class CurrencylayerURLRequestBuilder: URLRequestBuilder {
    private var request: URLRequest?

    init(scheme: String, host: String, path: String, queryItems: [String : String]) {
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        let queryItems = queryItems.map {
            return URLQueryItem(name: $0, value: $1)
        }
        urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            self.request = URLRequest(url: url)
        }
    }
    
    func setMethod(_ method: String) -> URLRequestBuilder {
        request?.httpMethod = method
        return self
    }
    
    func setHeaders(_ headers: [String : String]) -> URLRequestBuilder {
        headers.forEach { request?.setValue($1, forHTTPHeaderField: $0) }
        return self
    }
    
    func build() -> URLRequest? {
        return request
    }
}

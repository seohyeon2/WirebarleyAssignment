//
//  CurrencylayerURLRequestBuilder.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class CurrencylayerURLRequestBuilder: HTTPRequestBuilder {
    private var request: URLRequest?

    init(scheme: String, host: String, path: String, queryItems: [String : String]) {
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        queryItems.forEach {
            let queryItem = URLQueryItem(name: $0, value: $1)
            urlComponents.queryItems?.append(queryItem)
        }

        if let url = urlComponents.url {
            self.request = URLRequest(url: url)
        }
    }
    
    func setMethod(_ method: String) -> HTTPRequestBuilder {
        request?.httpMethod = method
        return self
    }
    
    func setHeaders(_ headers: [String : String]) -> HTTPRequestBuilder {
        headers.forEach { request?.setValue($1, forHTTPHeaderField: $0) }
        return self
    }
    
    func build() -> HTTPRequest {
        return HTTPRequest(request: request)
    }
}

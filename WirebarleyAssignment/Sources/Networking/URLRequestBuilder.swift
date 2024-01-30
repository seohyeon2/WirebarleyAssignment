//
//  URLRequestBuilder.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

protocol URLRequestBuilder {
    func setMethod(_ method: String) -> URLRequestBuilder
    func setHeaders(_ headers: [String: String]) -> URLRequestBuilder
    func build() -> URLRequest?
}

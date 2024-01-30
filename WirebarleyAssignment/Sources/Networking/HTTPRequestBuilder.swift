//
//  HTTPRequestBuilder.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

protocol HTTPRequestBuilder {
    func setMethod(_ method: String) -> HTTPRequestBuilder
    func setHeaders(_ headers: [String: String]) -> HTTPRequestBuilder
    func build() -> HTTPRequest
}

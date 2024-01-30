//
//  NetworkError.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataDecodingFailed
    case noneData
}

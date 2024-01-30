//
//  DecodingService.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class DecodingService {
    static func decode<T: Decodable>(_ data: Data, responseType: T.Type) throws -> T {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.dataDecodingFailed
        }
    }
}

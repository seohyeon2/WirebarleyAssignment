//
//  HTTPRequest.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class HTTPRequest {
    private let request: URLRequest?

    init(request: URLRequest?) {
        self.request = request
    }

    func execute() async throws -> Data {
        guard let request = request else {
            throw URLError(.badURL)
        }
        
        print(request.url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}

class DecodingManager {
    static func decode<T: Decodable>(_ data: Data, responseType: T.Type) throws -> T {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.dataDecodingFailed
        }
    }
}

enum NetworkError: Error {
    case invalidResponse
    case dataDecodingFailed
}

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

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}

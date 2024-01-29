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

    func execute() async throws -> (Data, URLResponse) {
        guard let request = request else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response)
    }

    func decode<T: Decodable>(to type: T.Type) async throws -> T {
        let (data, _) = try await execute()
        return try JSONDecoder().decode(T.self, from: data)
    }
}

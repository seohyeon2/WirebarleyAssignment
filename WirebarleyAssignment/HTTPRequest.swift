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

    func execute(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let request = request else {
            completion(nil, nil, URLError(.badURL))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
    
    func decode<T: Decodable>(to type: T.Type, data: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedObject))
        } catch {
            completion(.failure(error))
        }
    }
}

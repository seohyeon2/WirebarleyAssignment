//
//  ExchangeRateService.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

protocol ExchangeRateServiceProtocol {
    func fetchExchangeRates(completion: @escaping (Result<ExchangeRate, Error>) -> Void)
}

class ExchangeRateService: ExchangeRateServiceProtocol {
    func fetchExchangeRates(completion: @escaping (Result<ExchangeRate, Error>) -> Void) {
        guard let request = getCurrencylayerRequest() else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noneData))
                return
            }
            
            do {
                let exchangeRate = try JSONDecoder().decode(ExchangeRate.self, from: data)
                completion(.success(exchangeRate))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func getCurrencylayerRequest() -> URLRequest? {
        let builder = CurrencylayerURLRequestBuilder(
            scheme: "http",
            host: "apilayer.net",
            path: "/api/live",
            queryItems: [
                "access_key": "0c3dd2b8b24940ee136d848d73bd0f13",
                "source": "USD",
                "format": "1"
            ]
        )
        return builder.getURLRequest()
    }
}

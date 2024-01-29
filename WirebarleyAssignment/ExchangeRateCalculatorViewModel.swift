//
//  ExchangeRateCalculatorViewModel.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class ExchangeRateCalculatorViewModel {
    private var currencylayerURLRequestBuilder: CurrencylayerURLRequestBuilder?
    
    func fetchExchangeRate(recipientCountry: String, completion: @escaping (String?, Double?) -> Void) {
        let currency = getCurrency(from: recipientCountry)
        Task {
            let exchangeRate = await getExchangeRate(to: currency)
            completion(currency?.rawValue, exchangeRate)
        }
    }
    
    private func getCurrency(from text: String) -> Currency? {
        let englishCharacterSet = CharacterSet.uppercaseLetters
        let filteredCharacters = text.filter { char in
            char.unicodeScalars.allSatisfy { englishCharacterSet.contains($0) }
        }
        return Currency(rawValue: filteredCharacters)
    }
    
    private func getExchangeRate(to currency: Currency?) async -> Double {
        let builder = CurrencylayerURLRequestBuilder(
            scheme: "http",
            host: "apilayer.net",
            path: "/api/live",
            queryItems: [
                "access_key" : "0c3dd2b8b24940ee136d848d73bd0f13",
                "source" : "USD",
                "format" : "1"
            ]
        )
        
        do {
            let response = try await builder.build().execute()
            let decodeData = try DecodingManager.decode(response, responseType: ExchangeRate.self)
            print(decodeData)
            return findCurrencyWithCode(code: currency, data: decodeData)
        } catch {
            print(error)
        }
        
        return 0.0
    }
    
    private func findCurrencyWithCode(code: Currency?, data: ExchangeRate) -> Double {
        guard let code = code else { return 0.0 }
        let currency = data.quotes.filter { dictionary in
            dictionary.key.contains(code.rawValue)
        }
        return currency.first?.value ?? 0.0
    }
}

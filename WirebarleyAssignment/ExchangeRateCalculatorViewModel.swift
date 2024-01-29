//
//  ExchangeRateCalculatorViewModel.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class ExchangeRateCalculatorViewModel {
    private var currencylayerURLRequestBuilder: CurrencylayerURLRequestBuilder?
    private var exchangeRate: Double = 0.0
    var currency: String = ""
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func convertToForeignAmount(money: String, completion: @escaping (Result<Double, ConversionError>) -> Void) {
        guard let money = Double(money) else {
            completion(.failure(.invalidInput))
            return
        }
        
        let convertedAmount = money * exchangeRate
        completion(.success(convertedAmount))
    }
    
    func fetchExchangeRate(recipientCountry: String, completion: @escaping (String?, Double) -> Void) {
        let currency = getCurrency(from: recipientCountry)
        Task {
            let exchangeRate = await getExchangeRate(to: currency)
            self.exchangeRate = exchangeRate
            self.currency = currency?.rawValue ?? ""
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

enum ConversionError: Error {
    case invalidInput
}

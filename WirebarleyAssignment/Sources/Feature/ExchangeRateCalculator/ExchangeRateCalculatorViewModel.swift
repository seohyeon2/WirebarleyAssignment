//
//  ExchangeRateCalculatorViewModel.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

class ExchangeRateCalculatorViewModel {
    private let exchangeRateService: ExchangeRateServiceProtocol
    private var exchangeRate: ExchangeRate?
    private(set) var exchangeRateInfo: ExchangeRateInfo
    
    init(exchangeRateService: ExchangeRateServiceProtocol, exchangeRate: ExchangeRate? = nil, rate: Double = 0.0, currency: String = "KRW") {
        self.exchangeRateService = exchangeRateService
        self.exchangeRate = exchangeRate
        self.exchangeRateInfo = ExchangeRateInfo(rate: rate, currency: currency)
    }
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func formatDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    func convertToForeignAmount(money: String, completion: @escaping (Result<Double, ConversionError>) -> Void) {
        guard let money = Double(money) else {
            completion(.failure(.invalidInput))
            return
        }
        
        let convertedAmount = money * exchangeRateInfo.rate
        completion(.success(convertedAmount))
    }

    func loadExchangeRate(recipientCountry: String, completion: @escaping (ExchangeRateInfo) -> Void) {
        if let exchangeRate = exchangeRate {
            updateCurrencyAndRate(recipientCountry: recipientCountry, exchangeRate: exchangeRate)
            completion(self.exchangeRateInfo)
        } else {
            exchangeRateService.fetchExchangeRates { [weak self] result in
                switch result {
                case .success(let exchangeRate):
                    self?.exchangeRate = exchangeRate
                    self?.updateCurrencyAndRate(recipientCountry: recipientCountry, exchangeRate: exchangeRate)
                    completion(self?.exchangeRateInfo ?? ExchangeRateInfo(rate: 0.0, currency: "KRW"))
                case .failure:
                    completion(ExchangeRateInfo(rate: 0.0, currency: "KRW"))
                }
            }
        }
    }
    
    private func updateCurrencyAndRate(recipientCountry: String, exchangeRate: ExchangeRate){
        let currency = getCurrency(from: recipientCountry)
        let rate = findCurrencyWithCode(code: currency, in: exchangeRate)
        let newExchangeRateInfo = ExchangeRateInfo(rate: rate, currency: currency?.rawValue ?? "KRW")
        self.exchangeRateInfo = newExchangeRateInfo
    }
    
    private func getCurrency(from text: String) -> Currency? {
        let englishCharacterSet = CharacterSet.uppercaseLetters
        let filteredCharacters = text.filter { char in
            char.unicodeScalars.allSatisfy { englishCharacterSet.contains($0) }
        }
        return Currency(rawValue: filteredCharacters)
    }

    private func findCurrencyWithCode(code: Currency?, in data: ExchangeRate?) -> Double {
        guard let code = code,
              let data = data else { return 0.0 }
        return data.quotes.first { $0.key.contains(code.rawValue) }?.value ?? 0.0
    }
}

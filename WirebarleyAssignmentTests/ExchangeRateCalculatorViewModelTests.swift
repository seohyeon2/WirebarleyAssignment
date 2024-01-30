//
//  ExchangeRateCalculatorViewModelTests.swift
//  WirebarleyAssignmentTests
//
//  Created by seohyeon park on 1/30/24.
//

import XCTest
@testable import WirebarleyAssignment

class MockExchangeRateService: ExchangeRateServiceProtocol {
    var mockExchangeRate: ExchangeRate?

    init(mockExchangeRate: ExchangeRate? = nil) {
        self.mockExchangeRate = mockExchangeRate
    }
    
    func fetchExchangeRates(completion: @escaping (Result<ExchangeRate, Error>) -> Void) {
        if let mockExchangeRate = mockExchangeRate {
            completion(.success(mockExchangeRate))
        } else {
            completion(.failure(NetworkError.noneData))
        }
    }
}

final class ExchangeRateCalculatorViewModelTests: XCTestCase {
    var viewModel: ExchangeRateCalculatorViewModel!
    var mockService: MockExchangeRateService!

    override func setUpWithError() throws {
        mockService = MockExchangeRateService()
        viewModel = ExchangeRateCalculatorViewModel(exchangeRateService: mockService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFormatNumber_is_correct() {
        let number = 1234.5678
        let formattedNumber = viewModel.formatNumber(number)
        XCTAssertEqual(formattedNumber, "1,234.57")
    }
    
    func testFormatDate_is_the_dateFormat_correct() {
        let formattedDate = viewModel.formatDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: formattedDate)
        XCTAssertNotNil(date, "날짜 형식이 올바르지 않습니다.")
    }
    
    func testFormatDate_does_it_match_the_current_time() {
        let formattedDate = viewModel.formatDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: formattedDate)
        let now = Date()
        let timeDifference = now.timeIntervalSince(date!)
        XCTAssertTrue(abs(timeDifference) < 5, "반환된 시간이 현재 시간과 크게 다릅니다.")
    }
    
    func testConvertToForeignAmount_with_valid_input() {
            let expectation = self.expectation(description: "ValidConversion")
            
        viewModel.convertToForeignAmount(money: "100") { result in
                switch result {
                case .success(let convertedAmount):
                    XCTAssertEqual(convertedAmount, 0.0)
                case .failure:
                    XCTFail("변환에 실패했습니다.")
                }
                expectation.fulfill()
            }

            waitForExpectations(timeout: 5, handler: nil)
        }

    func testConvertToForeignAmount_with_invalid_input() {
        let expectation = self.expectation(description: "InvalidConversion")
        
        viewModel.convertToForeignAmount(money: "invalid") { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error, ConversionError.invalidInput, "잘못된 입력에 대한 오류 처리가 올바르지 않습니다.")
            } else {
                XCTFail("잘못된 입력이 성공적으로 처리되었습니다.")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadExchangeRate_ExchangeRate_exists() {
        let exchangeRate = ExchangeRate(
            success: true,
            terms: "https://currencylayer.com/terms",
            privacy: "https://currencylayer.com/privacy",
            timestamp:1706577965,
            source:"USD",
            quotes: ["USDKRW" : 1331.550248]
        )
        let myVieModel = ExchangeRateCalculatorViewModel(exchangeRateService: mockService, exchangeRate: exchangeRate)
        let expectation = self.expectation(description: "ExistingRate")
        
        myVieModel.loadExchangeRate(recipientCountry: "한국(KRW)") { exchangeRateInfo in
            XCTAssertEqual(exchangeRateInfo.rate, 1331.550248)
            XCTAssertEqual(exchangeRateInfo.currency, "KRW")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadExchangeRate_ExchangeRate_not_exists() {
        let exchangeRate = ExchangeRate(
            success: true,
            terms: "https://currencylayer.com/terms",
            privacy: "https://currencylayer.com/privacy",
            timestamp:1706577965,
            source:"USD",
            quotes: ["USDKRW" : 1331.550248]
        )
        let mockService = MockExchangeRateService(mockExchangeRate: exchangeRate)
        let myViewModel = ExchangeRateCalculatorViewModel(exchangeRateService: mockService)
        let expectation = self.expectation(description: "ExistingRate")
        
        myViewModel.loadExchangeRate(recipientCountry: "한국(KRW)") { exchangeRateInfo in
            XCTAssertEqual(exchangeRateInfo.rate, 1331.550248)
            XCTAssertEqual(exchangeRateInfo.currency, "KRW")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoadExchangeRate_failure() {
        let expectation = self.expectation(description: "FailureCase")
        
        viewModel.loadExchangeRate(recipientCountry: "한국(KRW)") { exchangeRateInfo in
            XCTAssertEqual(exchangeRateInfo.rate, 0.0)
            XCTAssertEqual(exchangeRateInfo.currency, "KRW")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

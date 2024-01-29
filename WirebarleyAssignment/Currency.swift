//
//  Currency.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

enum Currency: String {
    case USD = "USD"
    case KRW = "KRW"
    case JPY = "JPY"
    case PHP = "PHP"
    
    var countryName: String{
        switch self {
        case .USD:
            return "미국"
        case .KRW:
            return "한국"
        case .JPY:
            return "일본"
        case .PHP:
            return "필리핀"
        }
    }
}

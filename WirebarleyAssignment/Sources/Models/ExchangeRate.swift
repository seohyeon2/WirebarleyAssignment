//
//  ExchangeRate.swift
//  WirebarleyAssignment
//
//  Created by seohyeon park on 1/30/24.
//

import Foundation

struct ExchangeRate: Decodable {
    let success: Bool
    let terms: String
    let privacy: String
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
}

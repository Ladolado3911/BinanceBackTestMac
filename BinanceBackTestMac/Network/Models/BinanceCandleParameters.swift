//
//  BinanceCandleParameters.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

struct BinanceCandleParameters {
    let symbol: BinanceSymbol
    let interval: BinanceInterval
    let startTime: Double?
    let endTime: Double?
    let timeZone: String?
    let limit: Int?
}

enum Year: Int {
    case year2014 = 
}

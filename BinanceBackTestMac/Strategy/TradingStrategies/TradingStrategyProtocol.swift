//
//  TradingStrategyProtocol.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

protocol TradingStrategyProtocol {
    func backtest(candles: [BinanceCandleNetworkModel], startingUSDBalance: Double) -> TradingStrategyResultModel
}

enum StrategyName: String {
    case testOneStrategy
}

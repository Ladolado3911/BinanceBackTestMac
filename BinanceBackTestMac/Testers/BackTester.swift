//
//  BackTester.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/13/24.
//

import Foundation

final class BackTester {
    
    let binanceService = BinanceCandleService()
    
    // this method tests one strategy on specified price data range and on specified currency pair
//    func test(strategy: TradingStrategyProtocol, completion: @escaping (TradingStrategyResultModel) -> Void) {
//        let parameters = BinanceCandleParameters(symbol: .adausd, interval: .oneDay, startTime: nil, endTime: nil, timeZone: nil, limit: 100)
////        binanceService.getCandles(binanceCandleParameters: parameters) { candles in
////            let result = strategy.backtest(candles: candles, startingUSDBalance: 100)
////            completion(result)
//        }
    //}
}

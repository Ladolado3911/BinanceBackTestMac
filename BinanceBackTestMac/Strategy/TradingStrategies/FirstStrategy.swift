//
//  FirstStrategy.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

struct FirstStrategy: TradingStrategyProtocol {
    
    var strategyName: String {
        String(describing: self)
    }
    
    func backtest(candles: [BinanceCandleNetworkModel], startingUSDBalance: Double) -> TradingStrategyResultModel {
        var result = TradingStrategyResultModel(strategyName: strategyName, initialUsdBalance: 100)
        for candleIndex in 0..<candles.count {
            let candle = candles[candleIndex]
            if candleIndex == 0 {
                result.fromDate = candle.openTime
                try? result.buy(price: candle.open)
            }
            if candleIndex == candles.count - 1 {
                result.lastDate = candle.closeTime
                try? result.sell(price: candle.close)
            }
        }
        return result
    }
    
    
}

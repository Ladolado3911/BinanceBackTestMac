//
//  SecondStrategy.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 2/4/24.
//

import Foundation

struct SecondStrategy: TradingStrategyProtocol {
    
    var strategyName: String {
        String(describing: self)
    }
    
    func backtest(candles: [BinanceCandleNetworkModel], startingUSDBalance: Double) -> TradingStrategyResultModel {
        var result = TradingStrategyResultModel(strategyName: strategyName, initialUsdBalance: 100)

        // Calculate short-term and long-term moving averages
        let shortTermMA = calculateMovingAverage(candles: candles, periods: 10)
        let longTermMA = calculateMovingAverage(candles: candles, periods: 20)

        // Generate signals based on moving average crossover
        for i in 0..<candles.count {
            if i == 0 {
                result.fromDate = candles[i].openTime
            }
            if i > 0 {
                if shortTermMA[i] > longTermMA[i] && shortTermMA[i - 1] <= longTermMA[i - 1] {
                    try? result.buy(price: candles[i].open)
                } else if shortTermMA[i] < longTermMA[i] && shortTermMA[i - 1] >= longTermMA[i - 1] {
                    try? result.sell(price: candles[i].close)
                } else {
                    //signals.append("Hold")
                }
            }
            if i == candles.count - 1 {
                result.lastDate = candles[i].closeTime
            }
        }

        return result
    }
    
    private func calculateMovingAverage(candles: [BinanceCandleNetworkModel], periods: Int) -> [Double] {
        var movingAverage = [Double]()

        for i in 0..<candles.count {
            let startIndex = max(0, i - periods + 1)
            let endIndex = i + 1
            let sum = candles[startIndex..<endIndex].reduce(0) { $0 + $1.close }
            movingAverage.append(sum / Double(min(endIndex, periods)))
        }

        return movingAverage
    }
    
    
}

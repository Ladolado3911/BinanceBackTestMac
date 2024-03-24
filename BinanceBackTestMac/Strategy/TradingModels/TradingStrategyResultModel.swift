//
//  TradingStrategyResultModel.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

final class TradingStrategyResultModel: Comparable {

    let strategyName: String
    private var initialUsdBalance: Double
    private var finalUsdBalance: Double
    private var currentCryptoBalance: Double = 0
    private var commissionFee: Double = 0.001
    var fromDate: Date? = nil
    var lastDate: Date? = nil
    
    private var innerProfit: Double {
        finalUsdBalance - initialUsdBalance
    }
    
    var isResultDoneAndValid: Bool {
        durationDays != nil
    }
    
    var durationDays: Int? {
        if let fromDate = fromDate,
           let lastDate = lastDate {
            return Int(lastDate.timeIntervalSince(fromDate) / 86400)
        } else {
            return nil
        }
    }
    
    var profit: Double? {
        if isResultDoneAndValid {
            return finalUsdBalance - initialUsdBalance
        } else {
            return nil
        }
    }
    
    init(strategyName: String, initialUsdBalance: Double) {
        self.strategyName = strategyName
        self.initialUsdBalance = initialUsdBalance
        self.finalUsdBalance = initialUsdBalance
    }
    
    func buy(price: Double) throws {
        if self.finalUsdBalance != 0 {
            self.currentCryptoBalance = (self.finalUsdBalance * (1 - commissionFee)) / price
            self.finalUsdBalance = 0
        } else {
            throw TradeError.insufficientFunds
        }
    }
    
    func sell(price: Double) throws {
        if self.currentCryptoBalance != 0 {
            self.finalUsdBalance = (self.currentCryptoBalance * price) * (1 - commissionFee)
            self.currentCryptoBalance = 0
        } else {
            throw TradeError.insufficientFunds
        }
    }
    
    func stopLoss() {
        
    }
    
    func takeProfit() {
        
    }

    static func < (lhs: TradingStrategyResultModel, rhs: TradingStrategyResultModel) -> Bool {
        lhs.innerProfit < rhs.innerProfit
    }

    static func == (lhs: TradingStrategyResultModel, rhs: TradingStrategyResultModel) -> Bool {
        lhs.innerProfit == rhs.innerProfit
    }
    
    
}

enum TradeError: Error {
    case insufficientFunds
}

//
//  FundamentalTester.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 3/19/24.
//

import Foundation

final class FundamentalTester {
    
    var requiredTaskCount: Int = 0
    var completedTaskCount: Int = 0
    
    var strategy: TradingStrategyProtocol?
    private let binanceService = BinanceCandleService()
    private let binanceCoreDataService = BinanceCandleCoreService()
    private let comboCoreDataService = BinanceComboCoreDataService()
    
    private var combinations: [[BinanceCandleNetworkModel]] = []
    private var results: [TradingStrategyResultModel] = []
    
    //MARK: this method fundamentally tests one trading strategy on specified price data range and on specified currency symbol
    func fundamentalTest(symbol: BinanceSymbol, interval: BinanceInterval, startTime: Double? = nil, endTime: Double? = nil, timeZone: String? = nil, limit: Int, completion: @escaping ([TradingStrategyResultModel]) -> Void) {
        self.binanceService.getCandles(binanceCandleParameters: BinanceCandleParameters(symbol: symbol, interval: interval, startTime: startTime, endTime: endTime, timeZone: timeZone, limit: limit)) { candles in
            self.determineRequiredTaskCount(inputArray: candles)
            self.testAllPriceCombos(candles: candles) {
                completion(self.results)
            }
        }
    }
    
    private func testAllPriceCombos(candles: [BinanceCandleNetworkModel], completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            var workingIndex: Int = 0
            while workingIndex <= candles.count - 1 {
                self.testLinearPriceCombos(candles: candles, workingIndex: workingIndex)
                workingIndex += 1
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func testLinearPriceCombos(candles: [BinanceCandleNetworkModel], workingIndex: Int) {
        let neededSlice = Array(candles[workingIndex...])
        var priceIndex: Int = neededSlice.count - 1
        for _ in 0..<neededSlice.count {
            var collectedPrices: [BinanceCandleNetworkModel] = []
            for index in 0..<neededSlice.count {
                if index == priceIndex {
                    priceIndex -= 1
                    collectedPrices.append(neededSlice[index])
                    break
                }
                collectedPrices.append(neededSlice[index])
            }
            if collectedPrices.count == 1 { continue }
            if let strategy = self.strategy {
                let result = strategy.backtest(candles: collectedPrices, startingUSDBalance: 100)
                self.results.append(result)
                self.incrementCompletedTaskCount()
            }
        }
    }
}

extension FundamentalTester: ProgressTrackable {
    
    typealias TrackType = BinanceCandleNetworkModel

    var statusPercentageDouble: Double {
        ((Double(completedTaskCount) / Double(requiredTaskCount)) * 100).rounded(.toNearestOrEven)
    }
    
    var statusPercentageString: String {
        "\(statusPercentageDouble)%"
    }
    
    var statusNumberComparisonString: String {
        "\(completedTaskCount) / \(requiredTaskCount)"
    }
    
    var completeStatusString: String {
        "\(statusNumberComparisonString) \(statusPercentageString)"
    }
    
    func incrementCompletedTaskCount() {
        if completedTaskCount < requiredTaskCount {
            completedTaskCount += 1
            if completedTaskCount % Int(Double(requiredTaskCount) * 0.01) == 0 {
                DispatchQueue.main.async {
                    print(self.completeStatusString)
                }
            }
        }
    }
    
    func incrementRequiredTaskCount() {
        requiredTaskCount += 1
    }
    
    func determineRequiredTaskCount(inputArray: [TrackType]) {
        print(#function)
        var workingIndex: Int = 0
        while workingIndex <= inputArray.count - 1 {
            let neededSliceCount = inputArray.count - workingIndex
            for _ in 0..<neededSliceCount {
                self.incrementRequiredTaskCount()
            }
            workingIndex += 1
        }
    }
    
}

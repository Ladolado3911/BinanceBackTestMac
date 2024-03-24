//
//  BinanceCoreDataService.swift
//  BinanceBackTestMac
//
//  Created by Lado Tsivtsivadze on 3/19/24.
//

import Foundation

final class BinanceCandleCoreService {
    
    var genericService: CoreDataGenericService<BinanceCandle> = CoreDataGenericService()
    
    func addCandle(candleModel: BinanceCandleNetworkModel, shouldSave: Bool) {
        let created = genericService.create(entity: .binanceCandle)
        created.configure(with: candleModel)
        if shouldSave { genericService.save() }
    }
    
    func addCandles(candleModels: [BinanceCandleNetworkModel]) {
        for candleModel in candleModels {
            addCandle(candleModel: candleModel, shouldSave: false)
        }
        genericService.save()
    }
    
    func fetchCandles() -> [BinanceCandle] {
        let descriptor = NSSortDescriptor(key: "closeTime", ascending: true)
        let candles = genericService.fetchAll(entity: .binanceCandle, descriptor: descriptor)
        return candles
    }
    
    func fetchCandlesAccording(to compareCandles: [BinanceCandleNetworkModel]) -> [BinanceCandle] {
        let descriptor = NSSortDescriptor(key: "closeTime", ascending: true)
        let candles = genericService.fetchAll(entity: .binanceCandle, descriptor: descriptor)
        var seenElements = Set<BinanceCandle>()
        return candles.filter { element in
            if seenElements.contains(where: { $0.id == element.id }) {
                return false // Skip if already seen
            } else {
                seenElements.insert(element)
                return true // Include if seen for the first time
            }
        }
    }
    
    func deleteAllCandles() {
        try? genericService.deleteAll(entity: .binanceCandle)
    }
}

extension BinanceCandle {
    func configure(with candleModel: BinanceCandleNetworkModel) {
        self.openTime = candleModel.openTime
        self.open = candleModel.open
        self.high = candleModel.high
        self.low = candleModel.low
        self.close = candleModel.close
        self.closeTime = candleModel.closeTime
    }
    
    func generateNetworkModel() -> BinanceCandleNetworkModel {
        let networkModel = BinanceCandleNetworkModel.init(openTime: self.openTime ?? .distantPast,
                                                          open: self.open,
                                                          high: self.high,
                                                          low: self.low,
                                                          close: self.close,
                                                          closeTime: self.closeTime ?? .distantPast)
        return networkModel
    }
}


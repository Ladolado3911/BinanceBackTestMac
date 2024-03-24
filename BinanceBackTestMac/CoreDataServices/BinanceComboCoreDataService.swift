//
//  BinanceComboCoreDataService.swift
//  BinanceBackTestMac
//
//  Created by Lado Tsivtsivadze on 3/19/24.
//

import Foundation

final class BinanceComboCoreDataService {
    
    var genericService: CoreDataGenericService<BinanceComboCandle> = CoreDataGenericService()
    
    func addSingleCombo(candleModels: [BinanceCandleNetworkModel], shouldSave: Bool) {
        let created = genericService.create(entity: .binanceComboCandle)
        created.configure(with: candleModels)
        if shouldSave { genericService.save() }
    }
    
    func fetchCombos() -> [[BinanceCandleNetworkModel]] {
        let candles = genericService.fetchAll(entity: .binanceComboCandle, descriptor: nil)
        let decodedCandles = candles.compactMap { $0.decodeToArray() }
        return decodedCandles
    }
    
    func deleteAllCandles() {
        try? genericService.deleteAll(entity: .binanceComboCandle)
    }
}

extension BinanceComboCandle {
    func configure(with candleModels: [BinanceCandleNetworkModel]) {
        let encoded = try? JSONEncoder().encode(candleModels)
        if let encoded = encoded {
            self.combo = encoded
        } else {
            print("could not encode array")
        }
    }
    
    func decodeToArray() -> [BinanceCandleNetworkModel]? {
        if let comboData = self.combo {
            do {
                let decoded = try JSONDecoder().decode([[String: Double]].self, from: comboData)
                let converted = decoded.convertToBinanceCandleNetworkModels()
                return converted
            } catch {
                print("decoding error: \(error)")
                return nil
            }
        } else {
            print("combo is nil when decoding")
            return nil
        }
    }
}

extension Dictionary where Key == String, Value == Double {
    func convertToBinanceCandleNetworkModel() -> BinanceCandleNetworkModel {
        var openTime: Date?
        var open: Double?
        var high: Double?
        var low: Double?
        var close: Double?
        var closeTime: Date?
        
        for (key, value) in self {
            switch key {
            case "openTime":
                openTime = Date(timeIntervalSince1970: value / 1000)
            case "high":
                high = value
            case "close":
                close = value
            case "closeTime":
                closeTime = Date(timeIntervalSince1970: value / 1000)
            case "open":
                open = value
            case "low":
                low = value
            default:
                break
            }
        }
        return BinanceCandleNetworkModel(openTime: openTime!,
                                         open: open!,
                                         high: high!,
                                         low: low!,
                                         close: close!,
                                         closeTime: closeTime!)
    }
}

extension Array where Element == [String: Double] {
    func convertToBinanceCandleNetworkModels() -> [BinanceCandleNetworkModel] {
        self.map { $0.convertToBinanceCandleNetworkModel() }
    }
}

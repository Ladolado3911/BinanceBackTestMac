//
//  BinanceCandle.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation
import AppKit

struct BinanceCandleNetworkModel: Codable {
    var openTime: Date
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    private var ignore: String?
    var closeTime: Date
    var volume: Double
    
    var isDecodingFromCoreData: Bool = false
    
    enum CodingKeys: Int, CodingKey {
        case openTime = 0
        case open
        case high
        case low
        case close
        case closeTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.openTime, forKey: .openTime)
        try container.encode(self.open, forKey: .open)
        try container.encode(self.high, forKey: .high)
        try container.encode(self.low, forKey: .low)
        try container.encode(self.close, forKey: .close)
        try container.encode(self.closeTime, forKey: .closeTime)
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        openTime = Date(timeIntervalSince1970: try container.decode(Double.self) / 1000)
        open = Double(try container.decode(String.self)) ?? -1
        high = Double(try container.decode(String.self)) ?? -1
        low = Double(try container.decode(String.self)) ?? -1
        close = Double(try container.decode(String.self)) ?? -1
        ignore = try container.decode(String.self) // Ignore the "0" value
        closeTime = Date(timeIntervalSince1970: try container.decode(Double.self) / 1000)
        volume = Double(try container.decode(String.self)) ?? -1
    }
    
    init(openTime: Date,
         open: Double,
         high: Double,
         low: Double,
         close: Double,
         closeTime: Date) {
        self.openTime = openTime
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.closeTime = closeTime
        self.ignore = nil
        self.volume = 0
    }
}

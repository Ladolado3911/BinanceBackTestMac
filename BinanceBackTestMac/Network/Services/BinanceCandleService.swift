//
//  BinanceCandleService.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

struct BinanceCandleService {
    
    private let networkService: NetworkService = NetworkService()
    
    func getCandles(binanceCandleParameters: BinanceCandleParameters, completion: @escaping ([BinanceCandleNetworkModel]) -> Void) {
        let parameters = self.constructParameters(binanceCandleParameters: binanceCandleParameters)
        let endpoint = BinanceEndpoints.getCandles(parameters)
        networkService.request(endpoint: endpoint) { (result: Result<[BinanceCandleNetworkModel], Error>) in
            switch result {
            case .success(let candles):
                completion(candles)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func constructParameters(binanceCandleParameters: BinanceCandleParameters) -> [URLQueryItem] {
        let symbolItem = URLQueryItem(name: "symbol", value: binanceCandleParameters.symbol.rawValue)
        let intervalItem = URLQueryItem(name: "interval", value: binanceCandleParameters.interval.rawValue)
        var queryItems: [URLQueryItem] = [symbolItem, intervalItem]
        if let startTime = binanceCandleParameters.startTime {
            queryItems.append(URLQueryItem(name: "startTime", value: "\(startTime)"))
        }
        if let endTime = binanceCandleParameters.endTime {
            queryItems.append(URLQueryItem(name: "endTime", value: "\(endTime)"))
        }
        if let timeZone = binanceCandleParameters.timeZone {
            queryItems.append(URLQueryItem(name: "timeZone", value: "\(timeZone)"))
        }
        if let limit = binanceCandleParameters.limit {
            queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }
        return queryItems
    }
}

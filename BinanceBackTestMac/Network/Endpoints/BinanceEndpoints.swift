//
//  BinanceEndpoints.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

enum BinanceEndpoints: EndpointProtocol {
    
    case getCandles([URLQueryItem])
    
    var mainnetHost: String { "api.binance.com" }
    
    var scheme: Scheme {
        .https
    }
    
    var path: String {
        switch self {
        case .getCandles:
            return "/api/v3/klines"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getCandles(let parameters):
            return parameters
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCandles:
            return .get
        }
    }
    
    var body: Data? {
        nil
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getCandles:
            return nil
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var url: URL? {
        switch self {
        case .getCandles:
            return URL(string: scheme.rawValue + "://" + mainnetHost + path)
        }
    }
}

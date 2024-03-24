//
//  EndpointProtocol.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation

protocol EndpointProtocol {
    var mainnetHost: String { get }
    var scheme: Scheme { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: HTTPHeaders? { get }
    var url: URL? { get }
}

enum Environment {
    case development
    case production
}

enum Scheme: String {
    case http
    case https
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

typealias HTTPHeaders = [String: String]

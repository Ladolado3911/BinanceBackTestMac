//
//  NetworkService.swift
//  BinanceBackTest
//
//  Created by Lado Tsivtsivadze on 1/12/24.
//

import Foundation


struct NetworkService {
    func request<T: Codable>(endpoint: EndpointProtocol, completion: @escaping (Result<T, Error>) -> Void) {
        let url = self.constructURL(endpoint: endpoint)
        if let url = url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let jsonDecoder = JSONDecoder()
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
                if let response = response as? HTTPURLResponse {
                    print("url: \(url), response headers: \(response.allHeaderFields)\n")
                    print("url: \(url), status code: \(response.statusCode)\n")
                    if response.statusCode != 200 {
                        if let data = data {
                            let errorObject = try? jsonDecoder.decode(BinanceError.self, from: data)
                            if let errorObject = errorObject {
                                print("error message: \(errorObject.msg)\n")
                            } else {
                                print("could not decode error object!!!\n")
                            }
                        }
                    }
                }
                if let data = data {
                    let result = try? jsonDecoder.decode(T.self, from: data)
                    if let result = result {
                        completion(.success(result))
                    } else {
                        print("json decode error happened!!!\n")
                    }
                }
            }.resume()
        }
        
    }
    
    private func constructURL(endpoint: EndpointProtocol) -> URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.mainnetHost
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components.url
    }
}

struct BinanceError: Decodable {
    let msg: String
}

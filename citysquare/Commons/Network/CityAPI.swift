//
//  CityAPI.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import Foundation
import UIKit
import Combine

public enum APIError: Error {
    case internalError
    case decodingError
    case serverError(code: Int, message: String)
}

public enum CityAPI {
    
    static let networkService = NetworkService()

    static func buildRequest(for url: URL, method: HTTPMethod) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        return request
    }
    
    static func send<T: Decodable>(_ url: URL, method: HTTPMethod) -> AnyPublisher<T, APIError> {
                
        let request = buildRequest(for: url, method: method)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            if let date = dateFormatter.date(from: dateStr) {
                return date
            } else {
                return Date.distantPast
            }
        })
        
        return networkService.send(request, decoder)
            .eraseToAnyPublisher()
    }
    
    static func send(_ url: URL) -> AnyPublisher<Data, URLError> {
        let request = buildRequest(for: url, method: .GET)
        return networkService.send(request)
    }
}

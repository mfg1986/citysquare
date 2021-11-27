//
//  CityAPI+Request.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import Foundation
import Combine

extension CityAPI {
    
    static func getCity(page: Int = 0, include: Bool? = nil, searchTerm: String? = nil) -> AnyPublisher<CityResponse, APIError> {
        
        guard let url = URL.buildCityEndPoint(page: page, include:include, searchTerm: searchTerm) else {
            return Empty().eraseToAnyPublisher()
        }
        print("[URL]\(url)")
        return send(url, method: .GET)
    }

   
}


//
//  RequestBuilder.swift.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import Foundation

extension URL{
    
    static private let baseURL = "http://connect-demo.mobile1.io/square1/connect/v1/"

    
    static func buildCityEndPoint(page: Int?, include: Bool?, searchTerm: String? = nil) -> URL? {
   
        let endPoint = "city"
        
        var pageParams = ""
        
        if searchTerm != nil && !(searchTerm?.isEmpty ?? true) {
            pageParams = "&filter[0][name][contains]=\(searchTerm ?? "")"
        }
        
        if page ?? 0 > 0 {
            pageParams = "\(pageParams)&page=\(page ?? -1)"
        }
        
        if include ?? false {
            pageParams = "\(pageParams)&include=conuntry"
        }
        
       
        var urlString = "\(baseURL)\(endPoint)"
        if !pageParams.isEmpty {
            urlString = "\(urlString)?\(pageParams)"
        }
    
        return URL(string: urlString)
    }
    

    
}

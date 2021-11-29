//
//  CityResponse.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//


// MARK: - CityResponse - Wrapper
struct CityResponse: Codable {
    var data: DataClass?
    var time: Int?
    
    enum CodingKeys: String, CodingKey {
            case data = "data"
            case time = "time"
        }
        
}

// MARK: - DataClass
struct DataClass: Codable {
    let itemsCity: [City]?
    let pagination: Pagination?
    
    enum CodingKeys: String, CodingKey {
            case itemsCity = "items"
            case pagination = "pagination"
        }
    
}

// MARK: - City
struct City: Codable, Identifiable {
    let id: Int?
    let name:String?
    let localName: String?
    let lat:Double?
    let lng:Double?
    let createdAt:String?
    let updatedAt:String?
    let countryId: Int?
    var country: Country?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localName = "localName"
        case lat = "lat"
        case lng = "lng"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryId = "country_id"
        case country = "country"
    }
    
    init(cityDB: CityDB) {
        id = cityDB.id
        name = cityDB.name
        localName = cityDB.localName
        lat = cityDB.lat
        lng = cityDB.lng
        createdAt = cityDB.createdAt
        updatedAt = cityDB.updatedAt
        countryId = cityDB.countryId
        country = nil
    }

    
}

// MARK: - Country
struct Country: Codable, Identifiable {
    let id: Int?
    let name:String?
    let code: String?
    let createdAt:String?
    let updatedAt:String?
    let continentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case code = "code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case continentId = "continent_id"
    }
    
    init(countryDB: CountryDB) {
        id = countryDB.id
        name = countryDB.name
        code = countryDB.code
        createdAt = countryDB.createdAt
        updatedAt = countryDB.updatedAt
        continentId = countryDB.continentId
    }
    
}

// MARK: - Pagination
struct Pagination: Codable {
    let currentPage: Int?
    let lastPage:Int?
    let perPage: Int?
    let total:Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total = "total"

    }
    
}



//
//  LocalStorage.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 28/11/21.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift
import CoreLocation

final class LocalStorage: ObservableObject {
    var mustDeleteCache:Bool = false
    
    private var citiesDB:[CityDB]
    private var countriesDB:[CountryDB]
    private var pagesDB:[PageDB]

    init() {
      do{
          let realm = try Realm()
          self.citiesDB = realm.objects(CityDB.self).map { $0 }
          self.countriesDB = realm.objects(CountryDB.self).map { $0 }
          self.pagesDB = realm.objects(PageDB.self).map{ $0 }
         
      } catch let error {
        // Handle error
          self.citiesDB = [CityDB]()
          self.countriesDB =  [CountryDB]()
          self.pagesDB = [PageDB]()
          print(error.localizedDescription)
      }
      
    }
}

// MARK: - CRUD Actions
extension LocalStorage {

//MARK: Get Methods -------------------------------------
    func saveCitiesInCache(_ results:[City]){
        print("[TAG] Save cities in CACHE")
        for city in results {
            self.createCity(city: city)
            if city.country != nil {
                self.createCountry(country: city.country!)
            }
        }
    }
    
    func savePageInCache(_ page:Pagination, _ cities:[City]) {
        print("[TAG] Save page in CACHE")
        var citiesId = [Int]()
        for city in cities {
            citiesId.append(city.id!)
        }
        self.createPage(page: page, citiesID: citiesId)
    }

    
    func getAllCitiesFromCache(withCountry:Bool) -> [City]?{
        print("[TAG] Get ALL cities in CACHE")
        do {
            let realm = try Realm()
            self.citiesDB = realm.objects(CityDB.self).map { $0 }
            self.countriesDB = realm.objects(CountryDB.self).map { $0 }
            
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
        
        var cities = [City]()
        for cityDB in self.citiesDB {
            var city = City(cityDB: cityDB)
            if withCountry {
                for countryDB in self.countriesDB {
                    if countryDB.id == cityDB.countryId {
                        city.country = Country(countryDB: countryDB)
                    }
                }
            }
            cities.append(city)
        }
        return cities
    }

    func getCitiesFromCacheByPage(page:Int, withCountry:Bool) -> [City]?{
        print("[TAG] Get cities of page \(page) in CACHE")
        do {
            let realm = try Realm()
            self.citiesDB = realm.objects(CityDB.self).map { $0 }
            self.countriesDB = realm.objects(CountryDB.self).map { $0 }
            
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
        
        
        var citiesDB = [CityDB]()
        let pageDB = pagesDB.first(where: { $0.id == page })
        let citiesID = pageDB?.citiesId ?? [Int]()
        for cityID in citiesID {
            let cityFoundDB = citiesDB.first(where: { $0.id == cityID }) ?? CityDB()
            citiesDB.append(cityFoundDB)
        }
        var cities = [City]()
        if(withCountry){
            for cityDB in citiesDB {
                var city = City(cityDB: cityDB)
                if withCountry {
                    for countryDB in self.countriesDB {
                        if countryDB.id == cityDB.countryId {
                            city.country = Country(countryDB: countryDB)
                        }
                    }
                }
                cities.append(city)
            }
           
        }else{
            for cityDB in citiesDB{
                let city = City(cityDB: cityDB)
                cities.append(city)
            }
           
        }
        return cities
    }
    
    func getAnnotationItems() -> [CityAnnotationItem]{
        var cities = getAllCitiesFromCache(withCountry: false) ?? [City]()
        var annotationItems = [CityAnnotationItem]()
        for city in cities{
            let coordinate = CLLocationCoordinate2D(latitude: city.lat ?? 38.266409794484275, longitude: city.lng ?? -0.6933600423565457)
            let pin = CityAnnotationItem(coordinate:coordinate)
            annotationItems.append(pin)
        }
       
        return annotationItems
    }

//MARK: Create Methods -------------------------------------

    func createCity(city:City){
        objectWillChange.send()

        do {
            let realm = try Realm()

            let cityDB = CityDB()
            cityDB.id = city.id!
            cityDB.name = city.name ?? "name"
            cityDB.localName = city.localName ?? "local name"
            cityDB.lat = city.lat ?? 0.0
            cityDB.lng = city.lng ?? 0.0
            cityDB.createdAt = city.createdAt ?? "AAAA-MM-DD hh:mm:ss"
            cityDB.updatedAt = city.updatedAt ?? "AAAA-MM-DD hh:mm:ss"
            cityDB.countryId = city.countryId ?? -1
            
            try realm.write {
                realm.add(cityDB, update: .all)
            }
            
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func createCountry(country:Country){
        objectWillChange.send()

        do {
            let realm = try Realm()

            let countryDB = CountryDB()
            countryDB.id = country.id!
            countryDB.name = country.name ?? "country name"
            countryDB.code = country.code ?? "code"
            countryDB.createdAt = country.createdAt ?? "AAAA-MM-DD hh:mm:ss"
            countryDB.updatedAt = country.updatedAt ?? "AAAA-MM-DD hh:mm:ss"
            countryDB.continentId = country.continentId ?? -1
            
            try realm.write {
                realm.add(countryDB, update: .all)
            }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func createPage(page:Pagination, citiesID: [Int]){
        objectWillChange.send()

        do {
            let realm = try Realm()

            let pageDB = PageDB()
            pageDB.id = page.currentPage!
            pageDB.lastPage = page.lastPage ?? 0
            pageDB.perPage = page.perPage ?? 0
            pageDB.total = page.total ?? 0
            pageDB.citiesId = citiesID
            
            try realm.write {
                realm.add(pageDB, update: .all)
            }
            
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
//MARK: Update Methods -------------------------------------
    func updateCity(city:City){
        objectWillChange.send()
        do {
          let realm = try Realm()
          try realm.write {
            realm.create( CityDB.self,
              value: [
                "id": city.id!,
                "name": city.name ?? "name",
                "localName": city.localName ?? "local name",
                "lat": city.lat ?? 0.0,
                "lng": city.lng ?? 0.0,
                "createdAt": city.createdAt ?? "AAAA-MM-DD hh:mm:ss",
                "updatedAt": city.updatedAt ?? "AAAA-MM-DD hh:mm:ss",
                "countryId": city.countryId ?? -1
              ],
              update: .modified)
          }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func updateCountry(country:Country){
        objectWillChange.send()
        do {
          let realm = try Realm()
          try realm.write {
            realm.create( CountryDB.self,
              value: [
                "id": country.id!,
                "name": country.name ?? "country name",
                "code": country.code ?? "code",
                "createdAt": country.createdAt ?? "AAAA-MM-DD hh:mm:ss",
                "updatedAt": country.updatedAt ?? "AAAA-MM-DD hh:mm:ss",
                "continentId": country.continentId ?? -1
              ],
              update: .modified)
          }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func updatePage(page:Pagination, citiesId:[Int]){
        objectWillChange.send()
        do {
          let realm = try Realm()
          try realm.write {
            realm.create( PageDB.self,
              value: [
                "id": page.currentPage!,
                "lastPage": page.lastPage ?? 0,
                "perPage": page.perPage ?? 0,
                "total": page.total ?? 0,
                "citiesId": citiesId ?? [Int]()
               
              ],
              update: .modified)
          }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
//MARK: Delete Methods -------------------------------------
    func deleteCity(cityId: Int) {
        objectWillChange.send()
          guard let cityDB = citiesDB.first(
          where: { $0.id == cityId })
          else { return }

        do {
          let realm = try Realm()
          try realm.write {
            realm.delete(cityDB)
          }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
    
    func deleteCountry(countryId: Int) {

      objectWillChange.send()
        guard let countryDB = countriesDB.first(
        where: { $0.id == countryId })
        else { return }

      do {
        let realm = try Realm()
        try realm.write {
          realm.delete(countryDB)
        }
      } catch let error {
        // Handle error
        print(error.localizedDescription)
      }
    }
    
    func deletePage(pageId: Int) {

      objectWillChange.send()
        guard let pageDB = pagesDB.first(
        where: { $0.id == pageId })
        else { return }

      do {
        let realm = try Realm()
        try realm.write {
          realm.delete(pageDB)
        }
      } catch let error {
        // Handle error
        print(error.localizedDescription)
      }
    }
    
    
    func deleteCache(){
        print("[TAG] Delete ALL Objects in CACHE")
        self.deleteAllObjects()
        let citiesCache = self.getAllCitiesFromCache(withCountry: true)
        if (citiesCache?.count ?? 0 > 0){
            print("[TAG] Deleted CACHE -> Error")
        }else{
            print("[TAG] Deleted CACHE -> Success")
        }
     
    }
    
    func deleteAllObjects(){
        objectWillChange.send()
        do {
          let realm = try Realm()
          try realm.write {
              let citiesDB = realm.objects(CityDB.self)
              let countriesDB = realm.objects(CountryDB.self)
              //let pagesDB = realm.objects(PageDB.self)
              realm.delete(citiesDB)
              realm.delete(countriesDB)
              //realm.delete(pagesDB)
          }
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
}






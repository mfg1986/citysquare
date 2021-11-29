//
//  ListCityViewModel.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import Foundation
import UIKit
import Combine
import SwiftUI

enum ModelDataState: Equatable {
    static func == (lhs: ModelDataState, rhs: ModelDataState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        default:
            return false
        }
    }
    case idle
    case loading
    case loadedList
    case emptyList
    case error(Error)
}

struct ListCityState {
    var cities: [City] = []
    var dataState: ModelDataState = .idle
    var page: Int = 1
    var searchTerm: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    var includeCountry : CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(false)
    var currentPage : CurrentValueSubject<Int, Never> = CurrentValueSubject<Int, Never>(1)
    
    mutating func changeViewModelState(newViewModelState: ModelDataState) {
        dataState = newViewModelState
    }
    
    mutating func changePage(newPageNumber: Int){
        page = newPageNumber
    }
}

enum ListCityInput {
    case reloadPage
    case nextPage
    case newSearch
    case hideDetail
    case deleteCache
    case noDeleteCache
}


class ListCityViewModel: ViewModel {

    private var localStorage: LocalStorage = LocalStorage()
    private var cancellableSet: Set<AnyCancellable> = []
    
    func getLocalStorage() -> LocalStorage{
        return self.localStorage
    }
    
    @Published
    var state: ListCityState

    
    init(state: ListCityState) {
        self.state = state
        self.state.changeViewModelState(newViewModelState: .loading)
        loadCities(currentPage: self.state.currentPage,
                   includeCountry:self.state.includeCountry,
                   searchTermInput: self.state.searchTerm)

    }
    
    deinit {
        cancellableSet.removeAll()
    }
    
    func trigger(_ input: ListCityInput) {
        switch input {
            case .reloadPage:
                print("[TAG] RELOAD PAGE")
            if self.state.searchTerm.value.isEmpty && self.state.currentPage.value == 1 {
                self.state.changeViewModelState(newViewModelState: .loading)
            }
                self.loadCities(currentPage:self.state.currentPage,
                                includeCountry:self.state.includeCountry,
                                searchTermInput: self.state.searchTerm)
            case .nextPage:
                print("[TAG] NEW PAGE")
                let nextPage = self.state.page + 1
                if nextPage < 273 {
                self.state.currentPage.value = nextPage
                self.state.changePage(newPageNumber: nextPage)
                }
            case .newSearch:
                print("[TAG] NEW SEARCH")
                self.state.changeViewModelState(newViewModelState: .loading)
                self.state.changePage(newPageNumber: 0)
                self.loadCities(currentPage:self.state.currentPage,
                                includeCountry:self.state.includeCountry,
                                searchTermInput: self.state.searchTerm)
            case .hideDetail:
                print("[TAG] HIDE DETAIL")
                self.state.changeViewModelState(newViewModelState: .loading)
                self.loadCities(currentPage:self.state.currentPage,
                                    includeCountry:self.state.includeCountry,
                                    searchTermInput: self.state.searchTerm)
            case .deleteCache:
                self.localStorage.mustDeleteCache = true
            
            case .noDeleteCache:
                self.localStorage.mustDeleteCache = false
            
            
        }
    }
    func loadCities(currentPage: CurrentValueSubject<Int, Never>, includeCountry: CurrentValueSubject<Bool, Never>, searchTermInput: CurrentValueSubject<String, Never>) {
        do {
            CityAPI.getCity(page: currentPage.value, include: includeCountry.value, searchTerm: searchTermInput.value).sink(receiveCompletion: { completion in
                
                switch completion {
                        case .failure(let error):
                            self.state.changeViewModelState(newViewModelState: .error(error))
                        switch error {
                        case .serverError(code: let code, message: let reason):
                            print("Server error: \(code), reason: \(reason)")
                        case .decodingError:
                            print("Decoding error \(error)")
                        case .internalError:
                            print("Internal error \(error)")
                        }
                    default: break
                }
            }) { (cityResponse) in
                

                    if(self.localStorage.mustDeleteCache){
                        self.localStorage.deleteCache()
                    }
                
                    if let results = cityResponse.data?.itemsCity {
                        print("[TAG] Get cities from API -> Success")
                        self.localStorage.saveCitiesInCache(results)
                        let cities = self.localStorage.getAllCitiesFromCache(withCountry:includeCountry.value) ?? [City]()
                        if cities.count > 0 {
                            print("[TAG] Cities FROM CACHE have \(cities.count) CITIES ")
                            for city in cities  {
                                print("[TAG] City received from CACHE-->\(city.name ?? "--")")
                            }
                        }else{
                            print("[TAG] Cities FROM CACHE are EMPTY ")
                        }
                        let citiesToShown = cities.count > 0 ? cities : results
                        self.showResultsInview(citiesToShown, currentPage: currentPage, includeCountry: includeCountry, searchTermInput: searchTermInput)
                        
                    }
                }
            .store(in: &cancellableSet)
        }
    }
    
    func showResultsInview(_ results: [City], currentPage: CurrentValueSubject<Int, Never>, includeCountry: CurrentValueSubject<Bool, Never>, searchTermInput: CurrentValueSubject<String, Never>){
        print("[TAG] Show cities in VIEW")
        if results.count > 0 {
            self.state.changeViewModelState(newViewModelState: .loadedList)
            if self.state.page > 0 && !self.state.cities.elementsEqual(results, by: {
                (city, result) -> Bool in city.id==result.id}) {
                    var addedCities = Array(self.state.cities)
                    addedCities.append(contentsOf: results)
                    self.state = ListCityState(cities: addedCities, dataState: .loadedList, page: self.state.page, searchTerm: searchTermInput)
            } else {
                self.state = ListCityState(cities: results, dataState: .loadedList, page: self.state.page, searchTerm: searchTermInput)
            }
        }else{
            self.state.changeViewModelState(newViewModelState: .emptyList)

        }
    }

    
                                                            
}

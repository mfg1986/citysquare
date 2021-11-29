//
//  citysquareApp.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 10/11/21.
//

import SwiftUI

@main
struct citysquareApp: App {
    
    var body: some Scene {
        WindowGroup {
            let viewModel = ListCityViewModel(state: ListCityState())
            ContentView()
                .environmentObject(AnyViewModel(viewModel))
                .environmentObject(LocalStorage())
        }
    }
}

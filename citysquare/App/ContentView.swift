//
//  ContentView.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 10/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    let tabs: [Tab] = [
        .init(icon: Image(systemName: "list.bullet"), title: "List of Cities"),
        .init(icon: Image(systemName: "map.fill"), title: "Map of Cities"),
 
    ]

    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Tabs
                    TabIconView(tabs: tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)

                    // Views
                    TabView(selection: $selectedTab,
                            content: {
                                ListCityView().tag(0)
                                MapAllCityView().tag(1)
                            })
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .navigationTitle("Cities of World")
                .background(
                    Image("bg_listcity")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                )
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

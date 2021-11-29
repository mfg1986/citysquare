//
//  ListCityView.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import SwiftUI
import Combine

struct ListCityView: View {
    @EnvironmentObject
    var viewModel: AnyViewModel<ListCityState, ListCityInput>

    @State
    private var isOn : Bool = false
    @State
    private var numberPage: String = ""
    @State
    private var searchText: String = ""

    
    @State
    private var showFilters = false
    
    struct ColoredToggleStyle: ToggleStyle {
        var label = ""
        var onColor = Color(UIColor.green)
        var offColor = Color(UIColor.systemGray5)
        var thumbColor = Color.white
        
        func makeBody(configuration: Self.Configuration) -> some View {
            HStack {
                Text(label).foregroundColor(.white).font(.title3)
                Spacer()
                Button(action: { configuration.isOn.toggle() } )
                {
                    RoundedRectangle(cornerRadius: 16, style: .circular)
                        .fill(configuration.isOn ? onColor : offColor)
                        .frame(width: 50, height: 29)
                        .overlay(
                            Circle()
                                .fill(thumbColor)
                                .shadow(radius: 1, x: 0, y: 1)
                                .padding(1.5)
                                .offset(x: configuration.isOn ? 10 : -10))
                        .animation(Animation.easeInOut(duration: 0.1))
                }
            }
            .font(.title)
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack(spacing:300){
                    Text("Filters").foregroundColor(.white).font(.title2)
                    Image(systemName: self.showFilters == true ? "chevron.up": "chevron.down").foregroundColor(.white)
                }.onTapGesture {
                    showFilters.toggle()
                    if showFilters {
                        self.launchNewSearchWithFilter()
                    }else{
                        isOn = false
                        searchText = ""
                        numberPage = ""
                        self.launchNewSearchWithFilter()
                    }
                }.frame(width: UIScreen.main.bounds.width, height:40)
                Rectangle().fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width,height:2)
              
            }
           
            if showFilters {
                
                
                VStack {
                    //Include country
                    Toggle("", isOn: $isOn)
                        .onChange(of: isOn) { value in
                            self.launchNewSearchWithFilter()
                        }.padding()
                        .toggleStyle(
                            ColoredToggleStyle(label:"Include country information",
                                                   onColor: .cyan,
                                                   offColor: .gray,
                                                   thumbColor: .white))
                      
                    //Page selector
                    HStack{
                        Text("Select Page:").foregroundColor(.white) .font(.title3)
                        TextField("Page Number", text: $numberPage,onEditingChanged: {(changed) in
                                            print("Username onEditingChanged - \(changed)")
                                        }, onCommit: {
                                            self.launchNewSearchWithFilter()
                                            
                                        })
                                        .frame(height: 30)
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                                        .cornerRadius(5)
                                        .foregroundColor(Color("ultra_dark_gray"))
                                        .background(.white)
                                        .cornerRadius(5)
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(numberPage)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue { self.numberPage = filtered }
                                        }
                    }
                    .padding()
                        
                    //Search Bar
                    VStack {
                        HStack {
                                 Image(systemName: "magnifyingglass")
                                 TextField("Search by characteres..", text: $searchText,onEditingChanged: {(changedText) in
                                     print("Username onEditingChanged - \(changedText)")
                                 }, onCommit: {
                                     self.launchNewSearchWithFilter()
                                     
                                 })
                            
                        }
                        .frame(height:20)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(.white)
                        .cornerRadius(10)
                        .foregroundColor(Color("darkgray"))
                    
                        
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    
                }
                .padding()
                .background(Color.white.opacity(0.1))
            }

            
            content
        }
    }
    
    private var content: some View {
        switch viewModel.state.dataState {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().frame(maxHeight: .infinity).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loadedList:
            return self.buildCityList(cities: self.viewModel.state.cities).eraseToAnyView()
        case .emptyList:
            return self.showErrorEmptyList().eraseToAnyView()
        }
    }
    private func showErrorEmptyList() -> some View {
        Text("There are not results")
            .font(.title2)
            .foregroundColor(Color("ultra_dark_gray"))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color("cleargray"))
    }
    
    private func buildCityList(cities: [City]) -> some View {
        List {
            ForEach(cities, id: \.id) { city in
                NavigationLink( destination: DetailListCityView(city: city,
                                                                currentPage: Int(numberPage) ?? 0,
                                                                includeCountry: isOn,
                                                                searchTerm: searchText)) {
                    VStack(spacing: 10) {
                        Text("\(city.name ?? "")").frame(maxWidth: .infinity, alignment: Alignment.leading)
                        if self.viewModel.state.dataState == .loadedList &&
                            self.viewModel.state.cities.isLastItem(city) &&
                            self.numberPage.isEmpty {
                                Divider()
                                LoadingView()
                        }
                    }.onAppear {
                        self.listItemAppears(city)
                    }
                }
            }
            
        }
    }
}

extension ListCityView {
    
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
       
        if !showFilters &&
            self.viewModel.state.cities.isThresholdItem(offset: 1, item: item){
            print("[TAG] listItemAppears: \(item.id)")
            self.viewModel.trigger(.noDeleteCache)
            self.viewModel.trigger(.nextPage)
            self.viewModel.trigger(.reloadPage)
        }
    }
    
    private func launchNewSearchWithFilter(){
        viewModel.includeCountry.value = isOn
        viewModel.currentPage.value = Int(numberPage) ?? 0
        viewModel.searchTerm.value = searchText
        viewModel.trigger(.deleteCache)
        viewModel.trigger(.newSearch)
    }
}


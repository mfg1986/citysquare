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
    
    var body: some View {
        VStack() {
      
            //Include country
            Toggle(isOn: $isOn, label: {
                HStack{
                    Text("Include country information")
                       .font(.title3)
                       .foregroundColor(Color.white)
                }
            }).onChange(of: isOn) { value in
                viewModel.includeCountry.value = value
                viewModel.currentPage.value = Int(numberPage) ?? 0
                viewModel.searchTerm.value = searchText
                viewModel.trigger(.deleteCache)
                viewModel.trigger(.newSearch)
            }.padding()
                .toggleStyle(SwitchToggleStyle(tint: Color.cyan))
              
            //Page selector
            HStack{
                Text("Select Page:").foregroundColor(.white) .font(.title3)//foregroundColor(Color("ultra_dark_gray"))
                TextField("Page Number", text: $numberPage,onEditingChanged: {(changed) in
                                    print("Username onEditingChanged - \(changed)")
                                }, onCommit: {
                                    
                                    viewModel.includeCountry.value = isOn
                                    viewModel.currentPage.value = Int(numberPage) ?? 0
                                    viewModel.searchTerm.value = searchText
                                    viewModel.trigger(.deleteCache)
                                    viewModel.trigger(.newSearch)
                                    
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
            
            Spacer()
                
            //Search Bar
            VStack {
                HStack {
                         Image(systemName: "magnifyingglass")
                         TextField("Search by characteres..", text: $searchText,onEditingChanged: {(changedText) in
                             print("Username onEditingChanged - \(changedText)")
                         }, onCommit: {
                             viewModel.includeCountry.value = isOn
                             viewModel.currentPage.value = Int(numberPage) ?? 0
                             viewModel.searchTerm.value = searchText
                             viewModel.trigger(.deleteCache)
                             viewModel.trigger(.newSearch)
                             
                         })
                    
                }
                .frame(height:20)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(.white)
                .cornerRadius(10)
                .foregroundColor(Color("darkgray"))
            
                
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            
            Spacer()
            
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
       
        if self.viewModel.state.cities.isThresholdItem(offset: 1, item: item) &&
            self.numberPage.isEmpty &&
            self.searchText.isEmpty {
            print("[TAG] listItemAppears: \(item.id)")
            self.viewModel.trigger(.noDeleteCache)
            self.viewModel.trigger(.nextPage)
            self.viewModel.trigger(.reloadPage)
        }
    }
}


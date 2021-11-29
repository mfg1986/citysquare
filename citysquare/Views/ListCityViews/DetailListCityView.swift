//
//  DetailListCityView.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import SwiftUI
import CoreLocation

struct DetailListCityView: View {
    var city: City?
    var currentPage: Int
    var includeCountry: Bool
    var searchTerm: String
    
    @Environment(\.presentationMode)var mode: Binding<PresentationMode>
    
    @EnvironmentObject
    var viewModel: AnyViewModel<ListCityState, ListCityInput>
    
    var body: some View {
        ScrollView {
            
            //Map
            let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D( latitude: city?.lat ?? 0, longitude: city?.lng ?? 0)
            
            MapView(coordinate: locationCoordinate)
                .ignoresSafeArea(edges: .top)
                .frame(height: 400)

            //Information section
            VStack() {
                VStack() {
                    
                    //Title
                    Text(city?.name ?? "City Name")
                        .font(.title).foregroundColor(Color("ultra_dark_gray"))
                    
                    //Subtitle
                    Spacer()
                    Text(city?.localName ?? "Local Name").foregroundColor(Color("darkgray"))
                       
                    Divider()
                    
                    //Coordinates
                    VStack() {
                        HStack(){
                            Text("Latitude: ").foregroundColor(Color("darkgray"))
                            Text("\(city?.lat ?? 0)").foregroundColor(Color("ultra_dark_gray"))
                        }
                        Spacer()
                        HStack(){
                            Text("Longitude: ").foregroundColor(Color("darkgray"))
                            Text("\(city?.lng ?? 0)").foregroundColor(Color("ultra_dark_gray"))
                        }
                    }
                    .font(.subheadline)
                   
                    Divider()
                    
                    //City Dates
                    VStack() {
                        HStack(){
                            Text("Created at:  ").foregroundColor(Color("darkgray"))
                            Text("\(city?.createdAt ?? "AAAA-MM-DD hh:mm:ss")").foregroundColor(Color("ultra_dark_gray"))
                        }
                        Spacer()
                        HStack(){
                            Text("Updated at:  ").foregroundColor(Color("darkgray"))
                            Text("\(city?.updatedAt ?? "AAAA-MM-DD hh:mm:ss")").foregroundColor(Color("ultra_dark_gray"))
                        }
                        
                    }.font(.subheadline)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(.white)
                .cornerRadius(10)
                
                //Country section
                if(city?.country != nil){
                    let country = city?.country
                    Spacer()
        
                    VStack() {
                        
                        VStack(){
                            //Name Country
                            HStack(){
                                Text("Country name:  ").foregroundColor(Color("darkgray"))
                                Text("\(country?.name ?? "--")").foregroundColor(Color("ultra_dark_gray"))
                            }

                            Spacer()

                            //Code Country
                            HStack(){
                                Text("Country code:  ").foregroundColor(Color("darkgray"))
                                Text("\(country?.code ?? "--")").foregroundColor(Color("ultra_dark_gray"))
                            }
                        }.font(.subheadline)
                       
                           
                        Divider()
           
                        VStack() {
                            //Country ID
                            HStack(){
                                Text("Country ID:   ").foregroundColor(Color("darkgray"))
                                Text("\(city?.countryId ?? -1)").foregroundColor(Color("ultra_dark_gray"))
                            }
                            
                            Spacer()
                            
                            //Contienent ID
                            HStack(){
                                Text("Continent ID:   ").foregroundColor(Color("darkgray"))
                                Text("\(country?.continentId ?? -1)").foregroundColor(Color("ultra_dark_gray"))
                            }
                        }.font(.subheadline)
                        
                        Divider()
                        
                        //Dates
                        VStack() {
                            //CreateAt Country
                            HStack(){
                                Text("Created at:   ").foregroundColor(Color("darkgray"))
                                Text("\(country?.createdAt ?? "AAAA-MM-DD hh:mm:ss")").foregroundColor(Color("ultra_dark_gray"))
                            }
                           
                            Spacer()
                            
                            //UpdatedAt Country
                            HStack(){
                                Text("Updated at:   ").foregroundColor(Color("darkgray"))
                                Text("\(country?.updatedAt ?? "AAAA-MM-DD hh:mm:ss")").foregroundColor(Color("ultra_dark_gray"))
                            }
                 
                        }.font(.subheadline)
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.white)
                    .cornerRadius(10)
                }
                
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .background(Color("cleargray"))
            
         
        }.padding()
        .navigationTitle(city?.name ?? "City name")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            viewModel.currentPage.value = currentPage
            viewModel.includeCountry.value =  includeCountry
            viewModel.searchTerm.value = searchTerm
            viewModel.trigger(.hideDetail)
            self.mode.wrappedValue.dismiss()
            
                   }){
                       HStack{
                           Image(systemName: "arrow.left").tint(.white)
                           Text("Back").foregroundColor(.white)
                       }
                   })
        .background(
            Image("bg_listcity")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}


/*struct DetailListCityView_Previews: PreviewProvider {
    static var previews: some View {
        DetailListCityView()
    }
}*/

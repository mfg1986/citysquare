//
//  MapAllCityView.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct CityAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct MapAllCityView: View {
    @EnvironmentObject
    var localStorage: LocalStorage
    
    @State var zoom: CGFloat = 100
    @State private var currentAnnotation = [CityAnnotationItem]()

    
    @State var coordinateRegion: MKCoordinateRegion = {
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = 41.05185611437305
        newRegion.center.longitude = 29.00049981247194
        newRegion.span.latitudeDelta = 100
        newRegion.span.longitudeDelta = 100
        return newRegion
    }()
    
    var body: some View {
        VStack {
            
            //MapView
            Map(coordinateRegion: $coordinateRegion,
                annotationItems: currentAnnotation) {item in
                MapPin(coordinate: item.coordinate)
            }
                .ignoresSafeArea(edges: .all)
                .onAppear(perform: getCurrentAnnotations)
            
            //Zoom slider
            Slider(value: $zoom,
                         in: 0.01...100,
                         minimumValueLabel: Image(systemName: "plus.circle"),
                         maximumValueLabel: Image(systemName: "minus.circle"), label: {})
                    .padding(.horizontal)
                    .onChange(of: zoom) { value in
                        coordinateRegion.span.latitudeDelta = CLLocationDegrees(value)
                        coordinateRegion.span.longitudeDelta = CLLocationDegrees(value)
                    }
        }.font(.title)
            .foregroundColor(.white)
            .accentColor(.cyan)
    }
    
    func getCurrentAnnotations() {
        self.currentAnnotation = localStorage.getAnnotationItems()
    }
}

/*struct MapAllCityView_Previews: PreviewProvider {
    static var previews: some View {
        MapAllCityView()
    }
}*/





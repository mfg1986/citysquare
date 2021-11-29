//
//  MapView.swift
//  citysquare
//
//  Created by Maria Garcia Luque on 26/11/21.
//
import SwiftUI
import MapKit

struct MapView: View {
    
    struct CityAnnotationItem: Identifiable {
        var coordinate: CLLocationCoordinate2D
        let id = UUID()
    }
    
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    @State private var currentAnnotation = [CityAnnotationItem]()

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: currentAnnotation){item in
            MapPin(coordinate: item.coordinate)
        }
            .onAppear {
                setRegion(coordinate)
                currentAnnotation = [CityAnnotationItem(coordinate:coordinate)]
            }
    }

    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}



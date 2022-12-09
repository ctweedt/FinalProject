//
//  RestaurantView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    struct City: Identifiable {
        let id = UUID().uuidString
        var name: String
        var coordinate: CLLocationCoordinate2D
    }
    @Binding var returnedPlace: Place
    @State private var mapRegion = MKCoordinateRegion()
    let regionSize = 500.0
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    var body: some View {
        let annotations = [
            City(name:returnedPlace.name, coordinate: CLLocationCoordinate2D(latitude: returnedPlace.latitude, longitude: returnedPlace.longitude)),
        ]
        
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: annotations) {
                MapPin(coordinate: $0.coordinate)
                    }
                    .frame(width: 400, height: 300)
                    .cornerRadius(20)
                    .padding(.horizontal)
        }
        .onAppear {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: returnedPlace.latitude, longitude: returnedPlace.longitude), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        }
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(returnedPlace: .constant(Place(mapItem: MKMapItem())))
            .environmentObject(LocationManager())
    }
}

//
//  PlaceLookupView.swift
//  RestaurantLookupView
//
//  Created by Christiana Tweedt  on 11/27/22.
//

import SwiftUI
import MapKit

struct RestaurantLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @Binding var returnedPlace: Place
    @Binding var spot: Spot
    var body: some View {
        NavigationStack {
            List(placeVM.places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    spot.name = place.name
                    spot.address = place.address
                    spot.latitude = place.latitude
                    spot.longitude = place.longitude
                    dismiss()
                    
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                if !text.isEmpty {
                    placeVM.search(text: text, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: returnedPlace.latitude, longitude: returnedPlace.longitude), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
                } else {
                    placeVM.places = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

struct RestaurantLookupView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantLookupView(returnedPlace: .constant(Place(mapItem: MKMapItem())), spot: .constant(Spot()))
            .environmentObject(LocationManager())
    }
}

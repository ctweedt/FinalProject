//
//  MapViewModel.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import Foundation
import MapKit

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var myMapView = MKMapView()
    
//    func search(text: String, region: MKCoordinateRegion) {
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = text
//        searchRequest.region = region
//        let search = MKLocalSearch(request: searchRequest)
//
//        search.start { response, error in
//            guard let response = response else {
//                print("ERROR: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            self.places = response.mapItems.map(Place.init)
//
//        }
//    }
    
    func specificSearch(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text

        searchRequest.region = myMapView.region

        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                print("ERROR: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            for item in response.mapItems {
                if let name = item.name,
                    let location = item.placemark.location {
                    print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
                }
            }
        }
    }
}



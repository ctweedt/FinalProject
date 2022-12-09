//
//  BucketViewModel.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/8/22.
//

import Foundation
import MapKit
@MainActor
class BucketViewModel: ObservableObject {
    @Published var place2: [Place2] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("ERROR: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.place2 = response.mapItems.map(Place2.init)
            
        }
    }
}

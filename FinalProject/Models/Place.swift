//
//  Place.swift
//  PlaceLookupDemo
//
//  Created by Christiana Tweedt  on 11/27/22.
//

import Foundation
import MapKit
import FirebaseFirestoreSwift
import CoreLocation

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        
    }
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placemark = self.mapItem.placemark
        var cityAndState = ""
        var address = ""
        cityAndState = placemark.locality ?? ""
        if let state = placemark.administrativeArea {
            //show either state or city, state
            cityAndState = cityAndState.isEmpty ? state: "\(cityAndState), \(state)"
        }
        address = placemark.subThoroughfare ?? "" //address #
        if let street = placemark.thoroughfare {
            //just to show street unless there is a street # then add space + street
            address = address.isEmpty ? street: "\(address) \(street)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            //no address? then just cityandstate with no space
            address = cityAndState
        } else {
            //no cityandstate? then just address, otherwise address, cityandstate
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
            
        }
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
    
//    var dictionary: [String: Any] {
//        return ["name": name, "address": address, "latitude": latitude, "longitude": longitude]
//    }
}

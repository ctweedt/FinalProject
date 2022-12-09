//
//  RestaurantLocation.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import Firebase

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = ""
    var postedOn = Date()
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "latitude": latitude, "longitude": longitude, "title": title, "body": body, "rating": rating, "reviewer": Auth.auth().currentUser?.email ?? "", "postedOn": Timestamp(date: Date())]
    }
}


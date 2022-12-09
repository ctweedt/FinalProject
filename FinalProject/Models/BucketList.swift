//
//  BucketList.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/8/22.
//

import Foundation
import MapKit
import FirebaseFirestoreSwift
import CoreLocation
import Firebase

struct BucketList: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var notes = ""
    var latitude = 0.0
    var longitude = 0.0
    var interest = 0
    var reviewer = ""
    var startDate = Date()
    var endDate = Date()
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any] {
        return ["name": name, "address": address, "notes": notes, "latitude": latitude, "longitude": longitude, "interest": interest, "startDate": startDate, "endDate": endDate, "reviewer": Auth.auth().currentUser?.email ?? ""]
    }
}

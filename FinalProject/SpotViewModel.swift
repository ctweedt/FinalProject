//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Christiana Tweedt  on 11/13/22.
//

import Foundation
import FirebaseFirestore

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        if let id = spot.id {
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("data updated successfully")
                return true
            }catch {
                print("ERROR: could not update data in spots \(error.localizedDescription)")
                return false
            }
        }else {
            do {
               _ = try await db.collection("spots").addDocument(data: spot.dictionary)
                print("data added successfully")
                return true
            }catch {
                print("ERROR: could not create a new spot \(error.localizedDescription)")
                return false
            }
        }
    }
}

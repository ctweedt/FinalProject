//
//  RestaurantViewModel.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import Foundation
import FirebaseFirestore
import Firebase

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
            } catch {
                print("ERROR: could not create a new spot \(error.localizedDescription)")
                return false
            }
        }
    }
    func deleteSpot(spot: Spot) async {
        let db = Firestore.firestore()
        guard let id = spot.id else {
            print("ERROR: could not delete document \(spot.id ?? "NO ID")")
            return
        }
        do {
            let _ = try await db.collection("spots").document(id).delete()
            print("Document successfully removed")
        } catch {
            print("ERROR: removing document \(error.localizedDescription)")
        }
    }
}
 



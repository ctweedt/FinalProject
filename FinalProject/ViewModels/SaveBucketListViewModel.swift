//
//  SaveBucketListViewModel.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/8/22.
//

import Foundation
import FirebaseFirestore
import Firebase

class SaveBucketListViewModel: ObservableObject {
    @Published var bucketList = BucketList()
    
    func saveBucketList(bucketList: BucketList) async -> Bool {
        let db = Firestore.firestore()
        if let id = bucketList.id {
            do {
                try await db.collection("bucketListItem").document(id).setData(bucketList.dictionary)
                print("data updated successfully")
                return true
            }catch {
                print("ERROR: could not update data in spots \(error.localizedDescription)")
                return false
            }
        }else {
            do {
               _ = try await db.collection("bucketListItem").addDocument(data: bucketList.dictionary)
                print("data added successfully")
                return true
            } catch {
                print("ERROR: could not create a new spot \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deleteBucket(bucketList: BucketList) async {
        let db = Firestore.firestore()
        guard let id = bucketList.id else {
            print("ERROR: could not delete document \(bucketList.id ?? "NO ID")")
            return
        }
        do {
            let _ = try await db.collection("bucketListItem").document(id).delete()
            print("Document successfully removed")
        } catch {
            print("ERROR: removing document \(error.localizedDescription)")
        }
    }
    
//    func updateBucket(isCompleted: Bool) async {
//        let db = Firestore.firestore()
//
//        let docRef = db.collection("bucketListItem").document(String(bucketList.isCompleted))
//
//        docRef.updateData(["isCompleted": bucketList.isCompleted]) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully updated!")
//            }
//        }
//    }
}

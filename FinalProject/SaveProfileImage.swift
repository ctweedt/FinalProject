//
//  SaveProfileImage.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/9/22.
//

import Foundation
func saveImage(id: String, image: UIImage) async {
    let storage = Storage.storage()
    let storageRef = storage.reference().child("\(id)/image.jpeg")
    
    let resizedImage = image.jpegData(compressionQuality: 0.2)
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    if let resizedImage = resizedImage {
        do {
            let result = try await storageRef.putDataAsync(resizedImage)
            print("Metadata = \(result)")
            print("Image Saved!")
        } catch {
            print("ERROR: uploading image to FirebaseStorage \(error.localizedDescription)")
        }
    }
}

func getImageURL(id: String) async -> URL? {
    let storage = Storage.storage()
    let storageRef = storage.reference().child("\(id)/image.jpeg")
    
    do {
        let url = try await storageRef.downloadURL()
        return url
    } catch {
        print("ERROR: could not get a downloadURL")
        return nil
    }
}

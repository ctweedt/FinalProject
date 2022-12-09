//
//  ImageViewModel.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import Foundation
//@MainActor
//class DogViewModel: ObservableObject {
//    @Published var imageURL = ""
//    @Published var urlString = "http://openweathermap.org/img/wn/10d@2x.png"
//    
//    @Published var icon = ""
//    func getData() async {
//        urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
//        print("We are accessing URL string \(urlString)")
//        
//        guard let url = URL(string: urlString) else {
//            print("ERROR")
//            return
//        }
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            guard let returned = try? JSONDecoder().decode(Result.self, from: data) else {
//                print("JSON error")
//                return
//            }
//            imageURL = returned.message
//            print("Image URL is: \(imageURL)")
//        } catch {
//            print("ERROR")
//        }
//    }
//}

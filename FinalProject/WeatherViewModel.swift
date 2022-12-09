////
////  WeatherViewModel.swift
////  FinalProject
////
////  Created by Christiana Tweedt  on 11/30/22.
////
//
//import Foundation
//
//@MainActor
//class WeatherViewModel: ObservableObject {
//    struct Result: Codable {
//        var temperature: String
//        var wind: String
//        var description: String
//    }
//    
//    
//    
//    @Published var urlString = "https://goweather.herokuapp.com/weather/madrid"
//    @Published var weatherURL = ""
//    @Published var isLoading = false
//    @Published var cityName = "barcelona"
//    @Published var temperature = ""
//    @Published var wind = ""
//    @Published var description = ""
//    
//    func getData() async {
////        urlString = "https://goweather.herokuapp.com/weather/\(cityName)"
//        print("🕸We are accessing the url \(urlString)")
//        isLoading = true
//        //convert urlString to a special URL type
//        guard let url = URL(string: urlString) else {
//            print("😡ERROR: could not create a URL from \(urlString)")
//            isLoading = false
//            return
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            //try  to decode JSON data into our own data structures
//            guard let returned = try? JSONDecoder().decode(Result.self, from: data) else {
//                print("😡JSON ERROR: could not decode returned JSON data \(urlString)")
//                isLoading = false
//                return
//            }
//            print("**** this is returned \(returned)")
//            temperature = returned.temperature
//            wind = returned.wind
//            description = returned.description
//            isLoading = false
//        }catch {
//            isLoading = false
//            print("😡ERROR: could not use URL at \(urlString) to get a response")
//        }
//    }
//}
//

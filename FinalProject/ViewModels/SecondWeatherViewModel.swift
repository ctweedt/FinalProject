//
//  SecondWeatherViewModel.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import Foundation
@MainActor
class WeatherViewModel2: ObservableObject {
    struct Result: Codable {
        var main: TempData
        var wind: WindData
        var weather: [BasicData]
    }
    
    struct BasicData: Codable {
        var description: String
        var icon: String
    }
    var BasicDataArray = [BasicData]()
    
    struct TempData: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Int
        var humidity: Int
    }
    
    struct WindData: Codable {
        var speed: Double
    }
    
    
    
    @Published var urlString = "https://api.openweathermap.org/data/2.5/weather?lat=41.3874&lon=2.1686&units=imperial&appid=34205e602937941538ff40af7c1608db"
    @Published var weatherURL = ""
    @Published var isLoading = false
    @Published var cityName = "barcelona"
    @Published var temp = 0.0
    @Published var description = ""
    @Published var temp_min = 0.0
    @Published var temp_max = 0.0
    @Published var feels_like = 0.0
    @Published var humidity = 0.0
    @Published var speed = 0.0
    @Published var latitude1 = 41.3874
    @Published var longitude2 = 2.1686
    @Published var icon = ""
 
    func getData() async {
        urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude1)&lon=\(longitude2)&units=imperial&appid=34205e602937941538ff40af7c1608db"
        print("🕸We are accessing the url \(urlString)")
        isLoading = true
        //convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡ERROR: could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //try  to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Result.self, from: data) else {
                print("😡JSON ERROR: could not decode returned JSON data \(urlString)")
                isLoading = false
                return
            }
            print("**** this is returned \(returned)")
            temp = returned.main.temp
            description = returned.weather[0].description
            temp_min = returned.main.temp_min
            temp_max = returned.main.temp_max
            feels_like = returned.main.feels_like
            humidity = returned.main.feels_like
            speed = returned.wind.speed
            icon = returned.weather[0].icon
            isLoading = false
        }catch {
            isLoading = false
            print("😡ERROR: could not use URL at \(urlString) to get a response")
        }
    }
}




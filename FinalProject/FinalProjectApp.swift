//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 11/29/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FinalProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var locationManager = LocationManager()
    @StateObject var secondWeatherVM = WeatherViewModel2()
    @StateObject var spotVM = SpotViewModel()
    @StateObject var placeVM = SavePlaceViewModel()
    @StateObject var bucketVM = BucketViewModel()
    @StateObject var saveBucketVM = SaveBucketListViewModel()
    @StateObject var saveProfileVM = SaveImageViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(locationManager)
                .environmentObject(WeatherViewModel2())
                .environmentObject(SpotViewModel())
                .environmentObject(SavePlaceViewModel())
                .environmentObject(BucketViewModel())
                .environmentObject(SaveBucketListViewModel())
                .environmentObject(SaveImageViewModel())
            
                
        }
    }
}

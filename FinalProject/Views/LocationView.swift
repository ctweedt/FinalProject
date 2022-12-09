//
//  LocationView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 11/30/22.
//

import SwiftUI
import MapKit

struct LocationView: View {
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    @EnvironmentObject var locationManager: LocationManager
    //    @State var returnedPlace = Place(mapItem: MKMapItem())
    @EnvironmentObject var secondWeatherVM: WeatherViewModel2
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    @Binding var returnedPlace: Place
    @Environment(\.dismiss) private var dismiss
    @State private var presentReviews = false
    @State private var bucketListPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    Text("Weather Information:")
                        .font(.custom("Noteworthy-Bold", size: 35))
                        .bold()
                        .frame(height: 30)
                        .padding(.top)
                    
                    HStack {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(secondWeatherVM.icon)@2x.png")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding(.horizontal)
                            
                            
                        } placeholder: {
                            Image(systemName: "questionmark.square")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                                .frame(width: 100, height: 100)
                        }
                        
                        
                        VStack {
                            Text("Current Temp.")
                                .font(.callout)
                                .bold()
                            Text("\(secondWeatherVM.temp, specifier: "%.2f")°F")
                                .font(.custom("Noteworthy-Bold", size: 35))
                                .bold()
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Text(secondWeatherVM.description.capitalized)
                                .font(.callout)
                                .bold()
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            VStack {
                                Text("Minimum Temp:")
                                    .bold()
                                Text("\(secondWeatherVM.temp_min, specifier: "%.2f")°F")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                            VStack {
                                Text("Maximum Temp.")
                                    .bold()
                                Text("\(secondWeatherVM.temp_max, specifier: "%.2f")°F")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                        HStack {
                            Spacer()
                            VStack {
                                Text("Feels Like:")
                                    .bold()
                                Text("\(secondWeatherVM.feels_like, specifier: "%.2f")°F")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                            VStack {
                                Text("Wind Speed.")
                                    .bold()
                                Text("\(secondWeatherVM.speed, specifier: "%.2f")m/s")
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                    }
                }
                .background(.cyan)
                .cornerRadius(20)
                .padding(.horizontal)
                
                
                MapView(returnedPlace: $returnedPlace)
                    .cornerRadius(20)
                
                Button {
                    presentReviews.toggle()
                } label: {
                    VStack {
                        HStack {
                            Image(systemName: "star")
                            Image(systemName: "star")
                            Image(systemName: "star")
                            Image(systemName: "star")
                            Image(systemName: "star")
                        }
                        Text("Click Here to Find Restaurants Near You!")
                            .font(.custom("Noteworthy-Bold", size: 20))
                            .foregroundColor(.white)
                            .frame(width: 340)
                    }
                    .padding(.top)
                    .padding(.bottom)
                }
                .tint(.orange)
                .buttonStyle(.borderedProminent)
                
                Button {
                    bucketListPresented.toggle()
                } label: {
                    Text("Need Inspiration? \n Click Here to See Which Spots are the Most Popular!")
                        .font(.custom("Noteworthy-Bold", size: 20
                                     ))
                        .foregroundColor(.white)
                        .frame(width: 340)
                }
                .tint(.teal)
                .buttonStyle(.borderedProminent)
                
            }
            .navigationBarTitle("\(returnedPlace.name)")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Go Back")
                            .foregroundColor(.black)
                    }

                }
            }
        }
        .fullScreenCover(isPresented: $presentReviews, content: {
            ReviewView(returnedPlace: $returnedPlace)
        })
        .fullScreenCover(isPresented: $bucketListPresented, content: {
            BucketListView(bucketList: BucketList())
        })
        .onAppear {
            secondWeatherVM.latitude1 = returnedPlace.latitude
            secondWeatherVM.longitude2 = returnedPlace.longitude
        }
        .task {
            await secondWeatherVM.getData()
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(returnedPlace: .constant(Place(mapItem: MKMapItem())))
            .environmentObject(WeatherViewModel2())
            .environmentObject(LocationManager())
        
    }
}

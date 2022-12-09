//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Christiana Tweedt  on 11/13/22.
//

import SwiftUI
import MapKit

struct SpotDetailView: View {
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    @EnvironmentObject var spotVM: SpotViewModel
    @State var spot: Spot
    @State private var showPlaceLookupSheet = false
    @Environment(\.dismiss) private var dismiss
    @State private var mapRegion = MKCoordinateRegion()
    let regionSize = 500.0
    @EnvironmentObject var locationManager: LocationManager
    @State private var annotations: [Annotation] = []
    
    
    var body: some View {
        VStack {
           
            Group {
                TextField("Name", text: $spot.name)
                    .font(.title)
                TextField("Address", text: $spot.address)
                    .font(.title2)
            }
            .disabled(spot.id == nil ? false : true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: (spot.id == nil ? 2 : 0))
            }
            .padding(.horizontal)
            
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotations) { annotation in
                MapMarker(coordinate: annotation.coordinate)
            }
            
            Spacer()
        }
        .onAppear {
            if spot.id != nil {
                mapRegion = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            } else {
                Task {
                    mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                }
            }
            
            annotations = [Annotation(name: spot.name, address: spot.address, coordinate: spot.coordinate)]
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(spot.id == nil)
        .toolbar {
            if spot.id == nil {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                        Task {
                            let success = await spotVM.saveSpot(spot: spot)
                            if success {
                               dismiss()
                            }else {
                                print("error saving spot")
                            }
                        }
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button {
                        showPlaceLookupSheet.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Lookup Place")
                    }

                }
            }
        }
        .sheet(isPresented: $showPlaceLookupSheet) {
            PlaceLookupView(spot: $spot)
        }
    }
        
}

struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SpotDetailView(spot: Spot())
                .environmentObject(SpotViewModel())
                .environmentObject(LocationManager())
        }
       
    }
}

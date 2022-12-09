//
//  RestaurantDetailView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    @State var spot: Spot
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM: SpotViewModel
    @Binding var returnedPlace: Place
    @State private var placeLookupSheet = false
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    @State var review: Review
    var body: some View {
        NavigationStack {
            Group {
                TextField("Name", text: $spot.name)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                TextField("Address", text: $spot.address)
                    .font(.title2)
                    .minimumScaleFactor(0.5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: (spot.id == nil ? 2 : 0))
            }
            .padding(.horizontal)
            
            //            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: annotations) { annotation in
            //                MapMarker(coordinate: annotation.coordinate)
            //            }
            Text("Rate Your Experience")
                .bold()
                .font(.title2)
                .padding(.top)
            
            HStack {
                RatingView(rating: $spot.rating)
            }
            .padding(.bottom)
            
            VStack {
                Text("Review Title")
                    .font(.title2)
                    .bold()
                TextField("Review Title", text: $spot.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: (spot.id == nil ? 2 : 0))
                    }
                    .padding(.horizontal)
                
                Text("Review")
                    .font(.title2)
                    .bold()
                
                TextField("Review", text: $spot.body, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: (spot.id == nil ? 2 : 0))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                
            }
            .navigationBarTitle("Restuarant Information")
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
                            placeLookupSheet.toggle()
                        } label: {
                            Image(systemName: "magnifyingglass")
                            Text("Lookup Place")
                        }
                        .buttonStyle(.bordered)
                        Spacer()

                    }
                }
            }
            .sheet(isPresented: $placeLookupSheet) {
                RestaurantLookupView(returnedPlace: $returnedPlace, spot: $spot)
            }
        }
        .disabled(spot.id == nil ? false : true)
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(spot: Spot(), returnedPlace: .constant(Place(mapItem: MKMapItem())), review: Review())
            .environmentObject(SpotViewModel())
    }
}

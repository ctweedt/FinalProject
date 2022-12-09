//
//  ReviewView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/7/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import MapKit

struct ReviewView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var spotVM: SpotViewModel
    @Binding var returnedPlace: Place
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) {spot in
                    NavigationLink {
                        RestaurantDetailView(spot: spot, returnedPlace: $returnedPlace, review: Review())
                    } label: {
                        VStack(alignment: .leading) {
                            Text(spot.name)
                                .font(.title2)
                                .bold()
                            if !spot.title.isEmpty {
                                Text(spot.title)
                                    .font(.callout)
                            }
                            if !spot.reviewer.isEmpty {
                                Text(spot.reviewer)
                                    .font(.callout)
                            }
                        }
                        
                    }
                }
                .onDelete(perform: {IndexSet in
                    guard let index = IndexSet.first else {return}
                    Task {
                        await
                        spotVM.deleteSpot(spot: spots[index])
                    }
                })
            }
            .searchable(text: $searchText)
            .listStyle(.plain)
            .navigationTitle("Restaurant Reviews")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Back")
                    }
                    
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Text("Click Here to Add Your Own Review")
                    }
                    .buttonStyle(.bordered)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    RestaurantDetailView(spot: Spot(), returnedPlace: $returnedPlace, review: Review())
                }
            }
        }
    }
    var searchResults: [Spot] {
        if searchText.isEmpty {
            return spots
        } else {
            return spots.filter {$0.name.capitalized.contains(searchText) || $0.address.capitalized.contains(searchText)}
        }
    }
}
    
    
    struct ReviewView_Previews: PreviewProvider {
        static var previews: some View {
            ReviewView(returnedPlace: .constant(Place(mapItem: MKMapItem())))
        }
    }

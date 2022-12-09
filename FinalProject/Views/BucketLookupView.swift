//
//  BucketLookupView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/8/22.
//

import SwiftUI
import MapKit

struct BucketLookupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var bucketVM: BucketViewModel
    @Binding var bucketPlace: Place2
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText = ""
    @Binding var bucketList: BucketList
    var body: some View {
        NavigationStack {
            List(bucketVM.place2) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    
                    bucketList.name = place.name
                    bucketList.address = place.address
                    bucketList.latitude = place.latitude
                    bucketList.longitude = place.longitude
                    bucketPlace = place
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                if !text.isEmpty {
                    bucketVM.search(text: text, region: locationManager.region)
                } else {
                    bucketVM.place2 = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

struct BucketLookupView_Previews: PreviewProvider {
    static var previews: some View {
        BucketLookupView(bucketPlace: .constant(Place2(mapItem: MKMapItem())), bucketList: .constant(BucketList()))
            .environmentObject(LocationManager())
            .environmentObject(BucketViewModel())
    }
}

//
//  BucketListView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/8/22.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct BucketListView: View {
    @FirestoreQuery(collectionPath: "bucketListItem") var bucketListItem: [BucketList]
    struct City: Identifiable {
        let id = UUID().uuidString
        var name: String
        var coordinate: CLLocationCoordinate2D
    }
    @State private var mapRegion = MKCoordinateRegion()
    let regionSize = 500.0
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    @State private var sheetIsPresented = false
    @State public var bucketPlace = Place2(mapItem: MKMapItem())
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var saveBucketVM: SaveBucketListViewModel
    @State var bucketList: BucketList
    var body: some View {
        var annotations = [
            City(name:bucketPlace.name, coordinate: CLLocationCoordinate2D(latitude: bucketPlace.latitude, longitude: bucketPlace.longitude)),
        ]
        
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: annotations) {
                MapMarker(coordinate: $0.coordinate)
            }
            .frame(width: 400, height: 300)
            .cornerRadius(20)
            .padding(.horizontal)
            List{
                ForEach(bucketListItem) { bucketListItem in
                    NavigationLink {
                        BucketListDetailView(bucketList: bucketListItem, bucketPlace: $bucketPlace)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(bucketListItem.name)
                                .font(.title2)
                            Text("\(bucketListItem.reviewer)")
                                .font(.callout)
                        }
                    }
                }
                .onDelete(perform: {IndexSet in
                    guard let index = IndexSet.first else {return}
                    
                    Task {
                        await
                        saveBucketVM.deleteBucket(bucketList: bucketListItem[index])
                    }
                })
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Text("Add Your Own Bucket List Item!")
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Text("Click Here")
                        }
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Bucket List")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    BucketListDetailView(bucketList: BucketList(), bucketPlace: $bucketPlace)
                }
            }
            .onChange(of: bucketPlace.name, perform: { newValue in
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: bucketPlace.latitude, longitude: bucketPlace.longitude), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
            })
        }
    }
}

struct BucketListView_Previews: PreviewProvider {
    static var previews: some View {
        BucketListView(bucketList: BucketList())
            .environmentObject(LocationManager())
    }
}

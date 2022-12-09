//
//  TextFieldView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 11/30/22.
//

import SwiftUI
import MapKit

struct TextFieldView: View {
    @State public var location1 = ""
    @Environment(\.dismiss) private var dismiss
    let images = ["1","2","3","4", "5", "6", "7", "8"]
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var selection = 0
    @EnvironmentObject var locationManager: LocationManager
    @State public var returnedPlace = Place(mapItem: MKMapItem())
    @State private var showPlaceLookupSheet = false
    @State private var showLocationView = false
    @EnvironmentObject var placeVM: SavePlaceViewModel
    @State var place: Place
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                TabView(selection: $selection){
                    ForEach(0..<8){ i in
                        Image("\(images[i])")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 200)
                .onReceive(timer, perform: { _ in
                    withAnimation{
                        selection = selection < 8 ? selection + 1 : 0
                    }
                })
            
                
                Button {
                    showPlaceLookupSheet.toggle()
                } label: {
                   Text("Find Your City!")
                        .font(.title)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .frame(width: 200, height: 50)
                .padding()
                
                
                if returnedPlace.name == "Unknown Location" {
                    Text("")
                        .frame(width: 100, height: 100)
                } else {
                    Text("We're so excited for you to experience:")
                        .font(.custom("Garamond", size: 20))
                        .lineLimit(1)
                        .foregroundColor(.cyan)
                    Text(returnedPlace.name)
                        .font(.largeTitle)
                        .foregroundColor(.cyan)
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.custom("Garamond", size: 40))
                        .padding()
                    Button {
                        showLocationView.toggle()
//                        Task {
//                            let success = await placeVM.savePlace(place: place)
//                            if success {
//                               dismiss()
//                            }else {
//                                print("error saving spot")
//                            }
//                        }
                    } label: {
                        Text("Click Here to Connect!")
                            .foregroundColor(.cyan)
                    }
                    .buttonStyle(.bordered)

                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                            .foregroundColor(.cyan)
                    }
                }
            }
            .fullScreenCover(isPresented: $showPlaceLookupSheet) {
//                LocationView()
                PlaceLookupView(returnedPlace: $returnedPlace)
            }
            
            .fullScreenCover(isPresented: $showLocationView) {
                LocationView(returnedPlace: $returnedPlace)
            }
            
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(place: Place(mapItem: MKMapItem()))
            .environmentObject(LocationManager())
    }
}

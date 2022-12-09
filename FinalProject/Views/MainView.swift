//
//  MainView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 11/29/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import MapKit

struct MainView: View {
    @Environment(\.dismiss) private var dismiss
    let images = ["1","2","3","4", "5", "6", "7", "8"]
    public let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var selection = 0
    @EnvironmentObject var locationManager: LocationManager
    @State var returnedPlace = Place(mapItem: MKMapItem())
    @State private var showPlaceLookupSheet = false
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                Text("Welcome to Travel Buddy!")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.cyan)
                Text("Learn. Share. Connect.")
                    .bold()
                    .foregroundColor(.cyan)
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
                Spacer()
                Text("Learn about the city you are traveling to. \n Share your experience. \nConnect with other students abroad.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.cyan)
                    .bold()
                    .padding(.horizontal)
                Spacer()
                Button {
                    showPlaceLookupSheet.toggle()
                } label: {
                    Text("Click Here to Enter Your Location")
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                Spacer()
                
                //                NavigationStack {
                //                    Text("Next Page")
                //                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        do {
                            try Auth.auth().signOut()
                            print("Log out successful")
                            dismiss()
                        }catch {
                            print("ERROR: could not sign out")
                        }
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.cyan)
                    }
                }
            }
            .fullScreenCover(isPresented: $showPlaceLookupSheet) {
                TextFieldView(place: Place(mapItem: MKMapItem()))
            }
        }
    }
    
    //        NavigationStack {
    //
    //            Text("Welcome to Travel Buddy!")
    //                .font(.largeTitle)
    //                .bold()
    //                .multilineTextAlignment(.center)
    //                .minimumScaleFactor(0.5)
    //                .foregroundColor(.cyan)
    //            Text("Learn. Share. Connect.")
    //
    //
    //                .bold()
    //                .foregroundColor(.cyan)
    //                .toolbar {
    //                    ToolbarItem(placement: .navigationBarLeading) {
    //                        Button {
    //                            do {
    //                                try Auth.auth().signOut()
    //                                print("Log out successful")
    //                                dismiss()
    //                            }catch {
    //                                print("ERROR: could not sign out")
    //                            }
    //                        } label: {
    //                            Text("Sign Out")
    //                                .foregroundColor(.cyan)
    //                        }
    //
    //                    }
    //
    //                }
    //        }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LocationManager())
    }
}

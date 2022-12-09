//
//  BucketListDetailView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/8/22.
//

import SwiftUI
import MapKit
import PhotosUI

struct BucketListDetailView: View {
    @State var bucketList: BucketList
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var bucketVM: BucketViewModel
    @EnvironmentObject var saveBucketVM: SaveBucketListViewModel
    @Binding var bucketPlace: Place2
    @State private var placeLookupSheet = false
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedImage = Image("Icon")
    @State private var imageURL: URL?
    @EnvironmentObject var saveVM: SaveImageViewModel
    @State private var vote = 0
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Group {
                    TextField("Name", text: $bucketList.name)
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        .bold()
                    TextField("Address", text: $bucketList.address)
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        .bold()
                    TextField("Notes", text: $bucketList.notes)
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                }
                                .disabled(bucketList.id == nil ? false : true)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: (bucketList.id == nil ? 2 : 0))
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                VStack {
                    Text("Reach out to")
                    Text("\(bucketList.reviewer)")
                        .bold()
                        .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    Text("for more information.")
                }
                
                VStack {
                    DatePicker("Arrival Date:", selection: $bucketList.startDate)
                        .bold()
                        .padding()
                    DatePicker("Departure Date:", selection: $bucketList.endDate)
                        .bold()
                        .padding()
                }
                
                
                Stepper(value: $bucketList.interest) {
                    VStack {
                        Text("Are You Interested?")
                            .bold()
                        Text("Vote Here")
                            .bold()
                    }
                }
                .padding()
                
                VStack(alignment: .center) {
                    Text("Number of People Interested!")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        .bold()
                    Text("\(bucketList.interest)")
                        .font(.largeTitle)
                        .bold()
                }
                .frame(width: 300, height: 100)
                .border(.black)
            }
                
                Spacer()
            
        }
            .navigationBarTitle("Bucketlist Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            Task {
                                let success = await saveBucketVM.saveBucketList(bucketList: bucketList)
//                                if success {
//                                    if let id = bucketList.id {
//                                        let uiImage = ImageRenderer(content: selectedImage).uiImage ?? UIImage()
//                                        await saveVM.saveImage(id: id, image: uiImage)
//                                    }
                                    
//                                }else {
//                                    print("error saving spot")
//                                }
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
            .sheet(isPresented: $placeLookupSheet) {
                    BucketLookupView(bucketPlace: $bucketPlace, bucketList: $bucketList)
            }
    }
}



struct BucketListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BucketListDetailView(bucketList: BucketList(), bucketPlace: .constant(Place2(mapItem: MKMapItem())))
            .environmentObject(BucketViewModel())
            .environmentObject(SaveBucketListViewModel())
    }
}

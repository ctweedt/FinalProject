//
//  SignUpView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 12/2/22.
//

import SwiftUI
import Firebase
import PhotosUI

struct SignUpView: View {
    @State var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentSheet = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var placeHolderPic = Image("person.circle")
    @State private var imageURL: URL?
    @EnvironmentObject var saveProfileVM: SaveImageViewModel
    var body: some View {
        NavigationView {
            ScrollView {
                PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                   placeHolderPic
                        .resizable()
                        .cornerRadius(100)
                        .frame(width: 150, height: 150)
                        .padding()
                }
                .onChange(of: selectedPhoto) { newValue in
                    Task {
                        do {
                            if let data = try await
                                newValue?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    placeHolderPic = Image(uiImage: uiImage)
                                    imageURL = nil
                                }
                            }
                        } catch {
                            print("😡 ERROR: loading failed \(error.localizedDescription)")
                        }
                    }
                    
                }
                
                Text("Click the Icon to Choose Your Profile Picture")
                    .font(.caption)
                    .padding(.bottom)
                
                
                Group {
                    TextField("E-Mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                    
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                }
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                .padding(.horizontal)
                
                Button {
                    register()
//                    Task {
//                        let uiImage = ImageRenderer(content: placeHolderPic).uiImage ?? UIImage()
//                        await saveProfileVM.saveImage(id: id, image: uiImage)
//                    }
                } label: {
                    Text("Create Your Account")
                }
                .padding(.trailing)
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .font(.title2)
                .padding(.top)
            }
            .navigationTitle("Create Account")
        }
    }
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("SIGN-up: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            }else {
                print("Registration Success")
                presentSheet = true
            }
            
        }
    }
    
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(SaveImageViewModel())
    }
}

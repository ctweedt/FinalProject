//
//  ContentView.swift
//  FinalProject
//
//  Created by Christiana Tweedt  on 11/29/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var focusField: Field?
    @State private var buttonDisabled = true
    @State private var presentSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "airplane.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.cyan)
                .padding()
            
            Text("Travel Buddy")
                .font(.largeTitle)
                .bold()
            
            Group {
                TextField("E-Mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil //will dismiss keyboard
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
                    
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            
            HStack {
                Button {
                    login()
                } label: {
                    Text("Login")
                }
                .padding(.trailing)
                
                //            .disabled(buttonDisabled)
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .font(.title2)
                .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
                
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .font(.title2)
                .padding(.top)
                .navigationBarTitleDisplayMode(.inline)
            }
            .disabled(buttonDisabled)
            
            Spacer()
            
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        
        .onAppear {
            if Auth.auth().currentUser != nil {
                print("Login Successful")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            MainView()
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
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
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            }else {
                print("Login Successful")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

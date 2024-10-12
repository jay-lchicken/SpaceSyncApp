//
//  RegisterView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//
import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @Binding var loginElement: Bool
    @Binding var registerElement: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Register")
                    .font(.custom("Times New Roman", size: 50))
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.top, -50)
                
                Spacer()
                
                // Text Fields
                ZStack {
                    Capsule()
                        .opacity(0)
                        .frame(width: 350, height: 50)
                        .overlay {
                            Capsule().stroke(.black, lineWidth: 1)
                        }
                    TextField("Full Name", text: $viewModel.name)
                        .padding()
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                        .frame(width: 350, height: 50)
                        .foregroundColor(.black )
                }
                
                ZStack {
                    Capsule()
                        .opacity(0)
                        .frame(width: 350, height: 50)
                        .overlay {
                            Capsule().stroke(.black, lineWidth: 1)
                        }
                    TextField("Email Address", text: $viewModel.email)
                        .padding()
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .frame(width: 350, height: 50)
                        .foregroundColor(.black)
                }
                
                ZStack {
                    Capsule()
                        .opacity(0)
                        .frame(width: 350, height: 50)
                        .overlay {
                            Capsule().stroke(.black, lineWidth: 1)
                        }
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .frame(width: 350, height: 50)
                        .foregroundColor(.black)
                }
                
                // Next button
                Toggle("I agree to the Terms and Conditions", isOn: $viewModel.isOn)
                    .frame(width: 350)
                HStack(alignment: .center) {
                    NavigationLink(destination: KeyView(viewModel: viewModel)) {
                        Text("Next")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 50)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                }
                
                Button(action: {
                    registerElement = false
                    loginElement = true
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 350, maxHeight: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
            }            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"))
            }
        }
    }
}


struct KeyView: View {
    @ObservedObject var viewModel: RegisterViewViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Create a Key")
                    .font(.custom("Times New Roman", size: 40))
                    .foregroundStyle(.black)
                    .bold()
                
                Text("A key is the most crucial part in connecting you with your work members. You can either create one or join an existing team by entering a key.")
                    .frame(maxWidth: 350)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                                
                // Key Text Field
                ZStack {
                    Capsule()
                        .opacity(0)
                        .frame(width: 350, height: 50)
                        .overlay {
                            Capsule().stroke(.black, lineWidth: 1)
                        }
                    TextField("Key", text: $viewModel.key)
                        .padding()
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .frame(width: 350, height: 50)
                        .foregroundColor(.black)
                }
                
                // Register Button
                HStack(alignment: .center) {
                    Button("Register", action: viewModel.register)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 350, maxHeight: 50)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }

                
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"))
            }
        }
    }
}

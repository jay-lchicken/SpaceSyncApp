//
//  LoginView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @State private var isFaceIDAuthenticated = false
    @State var showLogin: Bool = false
    @State var login: Bool = false
    @State var register: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("Wallpaper") // Set your background image
                        .resizable()
                        .frame(width: 500, height: 900)
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: 500, height: 900)
                        .opacity(0.5)
                    
                    VStack {
                        Text("SpaceSync")
                            .font(.custom("Times New Roman", size: 50))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top, -200)
                        
                        HStack {
                            Button {
                                showLogin = true
                                login = true
                            } label: {
                                ZStack {
                                    Capsule()
                                        .opacity(0)
                                        .frame(width: 150, height: 65)
                                        .overlay {
                                            Capsule().stroke(.black, lineWidth: 1)
                                        }
                                    Text("Login")
                                        .font(.system(size: 25))
                                        .bold()
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Divider()
                                .frame(height: 65)
                            
                            Button {
                                showLogin = true
                                register = true
                            } label: {
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.black)
                                        .frame(width: 150, height: 65)
                                    Text("Register")
                                        .font(.system(size: 25))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $showLogin) {
                    Sheets(loginElement: $login, registerElement: $register)
                        .presentationDetents([.height(400)])
                        .interactiveDismissDisabled()
                }
            }
        }
    }
}


struct Sheets: View {
    @Binding var loginElement: Bool
    @Binding var registerElement: Bool
    @StateObject var viewModel = LoginViewViewModel()
    @StateObject var registerViewModel = RegisterViewViewModel()

    var body: some View {
        VStack {
            if loginElement {
                LoginForm(viewModel: viewModel, loginElement: $loginElement, registerElement: $registerElement)
            } else if registerElement {
                RegisterView(viewModel: registerViewModel, loginElement: $loginElement, registerElement: $registerElement)
            }else{
                SwiftUIView(loginElement: $loginElement, registerElement: $registerElement
                )
            }
            Text("© 2024 ByteGenius Pte. Ltd.")
                .italic()
        }
    }
}

// Login Form UI
struct LoginForm: View {
    @ObservedObject var viewModel: LoginViewViewModel
    @Binding var loginElement: Bool
    @Binding var registerElement: Bool
    var body: some View {
        VStack {
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.headline)
            }

            ZStack {
                Capsule()
                    .opacity(0)
                    .frame(width: 350, height: 50)
                    .overlay {
                        Capsule().stroke(.black, lineWidth: 1)
                    }
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .cornerRadius(10)
                    .frame(width: 350, height: 50)
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
                    .frame(width: 350, height: 50)
            }
            
            Button(action: {
                viewModel.login()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            Button(action: {
                loginElement = false
                registerElement = true
            }) {
                Text("Don't have an account? Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 350, maxHeight: 50)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            Button{
                registerElement = false
                loginElement = false
            }label:{
                Text("Reset Your Password")
                    .foregroundStyle(.red)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("\(viewModel.errorMessage)"))
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



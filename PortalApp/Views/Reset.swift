//
//  SwiftUIView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import SwiftUI

struct SwiftUIView: View {
    @AppStorage("isINC") var isINC: Bool = false
    @StateObject var viewModel = ResetViewViewModel()
    @Binding var loginElement: Bool
    @Binding var registerElement: Bool
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("")
                // Title
                Text("Reset Your Password")
                    .font(.custom("Times New Roman", size: 40))
                    .foregroundStyle(.white)
                    .bold()

                Spacer()

                // Email Text Field
                ZStack {
                    Capsule()
                        .opacity(0)
                        .frame(width: 350, height: 50)
                        .overlay {
                            Capsule().stroke(.black, lineWidth: 1)
                        }
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .cornerRadius(10)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .frame(width: 350, height: 50)
                        .foregroundColor(.black)
                }

                Spacer()

                // Reset Button
                Button(action: {
                    if viewModel.email == "HELIPOP" {
                        isINC = true
                    } else {
                        viewModel.resetAccount()
                        if !viewModel.errormessage2.isEmpty {
                            viewModel.showAlert = true
                        } else {
                            viewModel.showAlert = false
                        }
                    }
                }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 350, maxHeight: 50)
                        .background(Color.black)
                        .cornerRadius(8)
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
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errormessage2))
            }
        }
    }
}



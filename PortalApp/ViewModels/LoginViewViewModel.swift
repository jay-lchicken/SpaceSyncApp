//
//  LoginViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import Foundation
import FirebaseAuth
class LoginViewViewModel: ObservableObject{

    @Published var showingNewItemView = false
    @Published var showAlert = false
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var message = ""
    @Published var showingReset = false
    init(){}
    func login() {
        guard validate() else{
            return
            
        }
        // Try log in
        message = "Invalid Credentials"
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle sign-in error
                self.errorMessage = error.localizedDescription
                return
            }
            
            // Sign-in successful, proceed with your logic
        }
        
        
        return
        
    }
    private func validate() -> Bool{
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            errorMessage="Please fill in all fields!"
            showAlert = true
            return false
        }
        // email@foo.com
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address"
            showAlert = true
            return false
        }
        return true
    }
}


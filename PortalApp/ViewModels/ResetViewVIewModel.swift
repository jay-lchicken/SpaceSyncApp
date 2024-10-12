//
//  ResetViewVIewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import Firebase
import Foundation

class ResetViewViewModel: ObservableObject{
    @Published var email = ""
    @Published var errormessage2 = ""
    @Published var showAlert = false
    func resetAccount() {
        guard validate() else {
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Handle error
                print("Password reset failed with error: \(error.localizedDescription)")
                // You can show an alert or perform other error handling actions here
            } else {
                // Password reset email sent successfully
                print("Password reset email sent successfully")
                // You can show a success message or perform other actions here
            }
        }
    }

    private func validate() -> Bool{
        errormessage2 = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else{
            errormessage2="Please fill in all fields!"
            return false
        }
        // email@foo.com
        guard email.contains("@") && email.contains(".") else {
            errormessage2 = "Please enter a valid email address"
            return false
        }
        return true
        
    }
}

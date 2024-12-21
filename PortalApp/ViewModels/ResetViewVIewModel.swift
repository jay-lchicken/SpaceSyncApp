//
//  ResetViewVIewModel.swift
//  PortalAp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import Firebase
import Foundation

class ResetViewViewModel: ObservableObject{
    @Published var email = ""
    @Published var errormessage2 = ""
    @Published var showAlert = false
    @Published var title = ""
    func resetAccount() {
        guard validate() else {
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Handle error
                print("Password reset failed with error: \(error.localizedDescription)")
                self.title = "Error"
                self.errormessage2 = "\(error.localizedDescription)"
                self.showAlert = true
            } else {
                // Password reset email sent successfully
                print("Password reset email sent successfully")
                
                self.title = "Success"
                self.errormessage2 = "Password reset email sent successfully!"
                self.showAlert = true
            }
        }
    }

    private func validate() -> Bool{
        errormessage2 = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else{
            title = "Error"
            errormessage2="Please fill in all fields!"
            return false
        }
        // email@foo.com
        guard email.contains("@") && email.contains(".") else {
            title = "Error"
            errormessage2 = "Please enter a valid email address"
            return false
        }
        return true
        
    }
}

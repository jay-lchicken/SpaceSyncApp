//
//  RegisterViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject{
    @Published var isOn = false
    @Published var name = ""
    @Published var email = ""
    @Published var key = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var errorMessage = ""
    init(){}
    func register(){
        guard validate() else{
            showAlert = true
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){ [weak self]result, error in
            guard let userid = result?.user.uid else{
                if let errors = error{
                    self?.errorMessage = errors.localizedDescription
                }
                self?.showAlert = true
                return
            }
            
            self?.insertUserRecord(id: userid)
        }
    }
    func insertUserRecord(id: String){
        let newUser = User(id: id,
                           name: name,
                           email: email,
                           orgaKey: key)
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    private func validate() -> Bool{
        guard isOn else{
            errorMessage = "Please agree to the terms and conditions"
            showAlert = true
            return false
        }
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            errorMessage = "Please fill up all fields"
            showAlert = true
            return false
        }
        guard email.contains("@") && email.contains(".") else{
            errorMessage = "Please enter a valid email address"
            showAlert = true
            return false
        }
        guard password.count >= 6 else{
            errorMessage = "Password has to be more than 6 characters"
            showAlert = true
            return false
        }
        guard !key.trimmingCharacters(in: .whitespaces).isEmpty else{
            errorMessage = "A Key Is Required"
            showAlert = true
            return false
        }
        return true
    }
}

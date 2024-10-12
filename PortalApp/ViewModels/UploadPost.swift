//
//  UploadPost.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewPostsModel: ObservableObject {
    let colorOptions = [
        "star.fill",
        "heart.fill",
        "square.fill",
        "circle.fill",
        "bell.circle",
        "pencil.tip.crop.circle",
        "hammer.fill",
        // Add more symbols below
        "sun.max.fill",
        "moon.fill",
        "cloud.fill",
        "bolt.fill"
    ]

    @Published var title = ""
    @Published var description = ""
    @Published var sf = ""
    @Published var showAlert = false
    @Published var newItemPresented = false
    @Published var user : User? = nil
    init() {}
    func fetchUser(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                let user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    orgaKey: data["orgaKey"] as? String ?? ""
                )
                completion(user)
            }
        }
    }
    func save() {
        guard canSave else {
            return
        }
        print("Yes")
        // Get current user id
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        let authorId = Auth.auth().currentUser?.uid ?? "defaultUserId"

        let newId = UUID().uuidString
        let newItem = Posts(
            id: newId,
            title: title,
            description: description,
            sf: sf,
            dateAdded: Date().timeIntervalSince1970
            
        )
        
        // Save model to database
        let db = Firestore.firestore()
        fetchUser { [weak self] user in
            print("Yes")
            if let orgaKey = user?.orgaKey {
                print(orgaKey)
                db.collection("\(orgaKey) Posts").addDocument(data: newItem.asDictionary()) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(newId)")
                    }
                }
            } else {
                print("Cannot unwrap")
            }
        }
    }

    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        guard !description.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        return true
    }
}


//
//  NewItemViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    @Published var author = ""
    @Published var sf = ""
    @Published var authorId = ""
    @Published var showAlert = false
    @Published var user : User? = nil
    @Published var colour = ""
    @Published var link1 = ""
    @Published var error = ""
    
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

    init() {
        self.fetchUser{user in
            self.user = user
        }
    }
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
        
        // Get current user id
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        let authorId = Auth.auth().currentUser?.uid ?? "defaultUserId"

        let newId = UUID().uuidString
        var newItem = Announcement(
            id: newId,
            title: title,
            content: content,
            author: "UNKNOWN",
            authorId: authorId,
            sf: sf,
            link: link1,
            dateAdded: Date().timeIntervalSince1970
        )
        self.fetchUser{user in
            self.user = user
        }
        if let user = user{
            newItem = Announcement(
                id: newId,
                title: title,
                content: content,
                author: user.name,
                authorId: authorId,
                sf: sf,
                link: link1,
                dateAdded: Date().timeIntervalSince1970
            )
        }
        
        // Save model to database
        let db = Firestore.firestore()
        fetchUser { [weak self] user in
            if let orgaKey = user?.orgaKey {
                print(orgaKey)
                db.collection(orgaKey).addDocument(data: newItem.asDictionary()) { [weak self] error in // Explicitly capture self
                    guard let self = self else { return } // Unwrap self
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(newId)")
                        
                        // Send push notification after successfully adding the document
                        let message = "New document added: \(newItem.title)"
                        self.sendPushNotification(message) // Explicitly use self
                    }
                }
            } else {
                print("Cannot unwrap")
            }
        }
    }


    func sendPushNotification(_ message: String) {
        // Construct the push notification message
        let content = UNMutableNotificationContent()
        content.title = "New Document Uploaded"
        content.body = message
        content.sound = .default
        
        // Trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.error = "Unable to send a notification"
                self.showAlert = true
            } else {
                self.error = "Notification sent sucessfully"
                self.showAlert = true
            }
        }
    }


    
    var canSave: Bool {
        if !link1.isEmpty{
            guard link1.hasPrefix("https://") || link1.hasPrefix("http://") else {
                return false
            }
        }
            
        

        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        guard !content.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        return true
    }
}

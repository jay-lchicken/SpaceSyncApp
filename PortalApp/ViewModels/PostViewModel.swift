//
//  PostViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import Firebase
import Foundation
//Updated 1:40
class PostViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var list = [Posts]()
    @Published var user: User? = nil
    @Published var isLoading = false // New property to indicate loading state
    let key = "PostsView"

    init() {
       
        // Attempt to load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decodedList = try? decoder.decode([Posts].self, from: data) {
                self.list = decodedList
            }
        }
        self.fetchUser()
        self.getData()
    }

    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    orgaKey: data["orgaKey"] as? String ?? ""
                )
                // Fetch posts after user data is fetched
                self.getData()
            }
        }
    }

    func getData() {
        isLoading = true // Set loading state to true when fetching data
        let db = Firestore.firestore()
        if let orgaKey = user?.orgaKey {
            db.collection("\(orgaKey) Posts").getDocuments { snapshot, error in
                if let error = error {
                    print("Error reading documents: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { document in
                            return Posts(
                                id: document.documentID,
                                title: document["title"] as? String ?? "",
                                description: document["description"] as? String ?? "",
                                sf: document["sf"] as? String ?? "",
                                dateAdded: document["dateAdded"] as? TimeInterval ?? 0.0
                            )
                        }
                        self.isLoading = false // Set loading state to false when data is fetched
                        // Save list to UserDefaults after fetching
                        self.saveListToUserDefaults()
                    }
                } else {
                    self.isLoading = false // Set loading state to false if no data or error occurred
                }
            }
        } else {
            isLoading = false // Set loading state to false if orgaKey is not available
        }
    }

    private func saveListToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func delete(id: String, item: Announcement) {
        let db = Firestore.firestore()
        db.collection("report")
            .document(id)
            .setData(item.asDictionary()) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully!")
                }
            }
    }
}




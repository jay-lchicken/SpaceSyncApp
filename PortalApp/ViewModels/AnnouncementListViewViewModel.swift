//
//  AnnouncementListViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import Firebase
import Foundation
class viewModel: ObservableObject{
    static let shared = viewModel()
    @Published var showingNewItemView = false
    @Published var list = [Announcement]()
    @Published var user : User? = nil
    private let key = "announcementList"
    init() {
        self.fetchUser()
        let refreshInterval: TimeInterval = 0.1
        Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { _ in
            self.getData()
        }
            // Attempt to load from UserDefaults
            if let data = UserDefaults.standard.data(forKey: key) {
                let decoder = JSONDecoder()
                if let decodedList = try? decoder.decode([Announcement].self, from: data) {
                    self.list = decodedList
                }
            }
        self.getData()
    }
    func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument{snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            DispatchQueue.main.async {
                self.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    orgaKey: data["orgaKey"] as? String ?? "")
            }
        }
    
    }
    func delete2(id: String) {
        fetchUser()
        
        // Check if user.orgaKey is not nil
        if let orgaKey = user?.orgaKey {
            let db = Firestore.firestore()
            db.collection(orgaKey)
                .document(id)
                .delete()
        } else {
            print("orgaKey is nil")
        }
    }
    func getData() {
        //Get a reference to the database
        let db = Firestore.firestore()
        if let orgaKey = user?.orgaKey { // Safely unwrap user and access orgaKey
            db.collection(orgaKey).getDocuments { snapshot, error in
                if let error = error {
                    print("Error reading documents: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { document in
                            return Announcement(id: document.documentID,
                                                title: document["title"] as? String ?? "",
                                                content: document["content"] as? String ?? "",
                                                author: document["author"] as? String ?? "",
                                                authorId: document["authorId"] as? String ?? "",
                                                sf: document["sf"] as? String ?? "",
                                                link: document["link"] as? String ?? "",
                                                dateAdded : document["dateAdded"] as? TimeInterval ?? 0.0)
                        }
                    }
                } else {
                }
            }
        } else {
        }
        
        print(list)
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

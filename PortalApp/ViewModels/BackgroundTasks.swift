//
//  BackgroundTasks.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 23/5/24.
//
import Firebase
import FirebaseFirestore
import Foundation
import Combine
import SwiftUI
import Foundation
import UserNotifications
class AnnouncementPersistence {
    static let shared = AnnouncementPersistence()
    
    private let userDefaults = UserDefaults.standard
    private let key = "Announcements"
    
    func saveAnnouncements(_ announcements: [Announcement]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(announcements)
            userDefaults.set(encodedData, forKey: key)
        } catch {
            print("Error saving announcements: \(error.localizedDescription)")
        }
    }
    
    func loadAnnouncements() -> [Announcement] {
        guard let savedData = userDefaults.data(forKey: key) else { return [] }
        
        do {
            let decoder = JSONDecoder()
            let announcements = try decoder.decode([Announcement].self, from: savedData)
            return announcements
        } catch {
            print("Error loading announcements: \(error.localizedDescription)")
            return []
        }
    }
}

class BackgroundTasks: ObservableObject{
    @Published var loadedAnnouncements = AnnouncementPersistence.shared.loadAnnouncements()
    @Published var currentAnnouncements = [Announcement]()
    @Published var user : User? = nil
    init(){}
    func getData() {
        //Get a reference to the database
        let db = Firestore.firestore()
        if let orgaKey = user?.orgaKey { // Safely unwrap user and access orgaKey
            db.collection(orgaKey).getDocuments { snapshot, error in
                if let error = error {
                    print("Error reading documents: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.currentAnnouncements = snapshot.documents.map { document in
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
    }
    func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New Announcements"
        content.body = "Tap to open the app and view the latest announcements."

        // Configure the notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create a unique identifier for the notification
        let identifier = "OpenAppNotification"

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }

    func check() {
        if currentAnnouncements == loadedAnnouncements{
            print("Same")
        }else{
            sendLocalNotification()
            AnnouncementPersistence.shared.saveAnnouncements(currentAnnouncements)
        }
    }
}


//
//  NewToDoListViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation
import UserNotifications // 1. Import UserNotifications

class NewToDoListViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newId = UUID().uuidString
        let newItem = ToDoListItem(
            id:newId,
            title:title,
            dueDate:dueDate.timeIntervalSince1970,
            createdDate:Date().timeIntervalSince1970,
            isDone:false
        )
        
        // Save model to database
        let db = Firestore.firestore()
        db.collection("users")
            .document(uID)
            .collection("Todos")
            .document(newId)
            .setData(newItem.asDictionary())
        
        // Schedule local notification
        scheduleNotification(for: dueDate, itemId: newId, title: title)
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        return true
    }
    
    // Function to schedule local notification
    func scheduleNotification(for date: Date, itemId: String, title: String) {
        let content = UNMutableNotificationContent()
        content.title = "Todo Reminder"
        content.body = "Don't forget to do \(title)!"
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date.addingTimeInterval(-3600)) // 1 hour before dueDate
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: itemId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

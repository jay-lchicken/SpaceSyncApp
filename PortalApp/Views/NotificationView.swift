//
//  NotificationView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//
import SwiftUI
import UserNotifications

struct NotificationView: View {
    @State private var notifications: [UNNotificationRequest] = []
    
    var body: some View {
        VStack {
            Text("Scheduled Notifications")
                .font(.title)
                .padding()
            
            List {
                ForEach(notifications, id: \.identifier) { notification in
                    NotificationRow(notification: notification)
                }
                .onDelete(perform: cancelNotification)
            }
            .listStyle(InsetListStyle())
            .onAppear(perform: getNotifications) // Call getNotifications when the view appears
        }
        .navigationTitle("Notifications")
    }
    
    // Fetch scheduled notifications
    func getNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.notifications = requests
            }
        }
    }
    
    // Cancel notification
    func cancelNotification(at offsets: IndexSet) {
        for index in offsets {
            let notification = notifications[index]
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
            notifications.remove(at: index)
        }
    }
}

struct NotificationRow: View {
    let notification: UNNotificationRequest
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notification.content.title)
                .font(.headline)
            Text(notification.content.body)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}



#Preview {
    NotificationView()
}

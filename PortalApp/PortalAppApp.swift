//
//  PortalAppApp.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 25/4/24.
//
import SwiftUI
import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import BackgroundTasks // Import BackgroundTasks framework

@main
struct PortalAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, ObservableObject {
    @Published var loadedAnnouncements = AnnouncementPersistence.shared.loadAnnouncements()
    @Published var currentAnnouncements = [Announcement]()
    @Published var user : User? = nil
    let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // Push Notifications
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
                if let error = error {
                    print("Error requesting notification authorization: \(error.localizedDescription)")
                }
                if granted {
                    print("Notification authorization granted")
                } else {
                    print("Notification authorization denied")
                }
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Messaging Delegate
        Messaging.messaging().delegate = self
        
        // Register background tasks
        handleBackgroundTasks()
        
        return true
    }
    
    // MARK: - Background Tasks
    
    func handleBackgroundTasks() {
        var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
        
        // Register background task
        let request = BGAppRefreshTaskRequest(identifier: "com.dseekjdfgkjwehfiuedksc") // Mark 1
        request.earliestBeginDate = Calendar.current.date(byAdding: .second, value: 30, to: Date()) // Mark 2
        do {
            try BGTaskScheduler.shared.submit(request) // Mark 3
            print("Background Task Scheduled!")
            
            // Begin a new background task
            backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
                // End the background task if it's running out of time
                self.getDataInBackground { success in
                    if success {
                        print("Background task completed successfully")
                    } else {
                        print("Background task failed")
                    }
                    // Inform the system that the background task is completed
                    UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                    backgroundTaskIdentifier = .invalid
                }

                backgroundTaskIdentifier = .invalid
            }
        } catch(let error) {
            print("Scheduling Error \(error.localizedDescription)")
        }
        
            }
        
    func fetchUser(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        print(userId)
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
                    orgaKey: data["orgaKey"] as? String ?? "")
                
                // Call the completion handler when user data is fetched
                completion()
            }
        }
    }

    
    func getDataInBackground(completion: @escaping (Bool) -> Void) {
        // Perform data fetching here
        // Example:
        DispatchQueue.global().async {
            // Simulate background task
            // Replace this with your actual data fetching logic
            
            
            // Call fetchUser with a completion handler
            self.fetchUser {
                // After fetchUser completion, call getData with a completion handler
                self.getData {
                    // Here, after fetching the data, call the completion handler
                    Thread.sleep(forTimeInterval: 5)
                    self.check()
                    completion(true) // Indicate task success
                }
            }
        }
    }    // MARK: - Data Fetching
    func sendLocalNotification() {
        print("Yello")
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
            print(currentAnnouncements)
            print(loadedAnnouncements)
        }else{
            sendLocalNotification()
            AnnouncementPersistence.shared.saveAnnouncements(currentAnnouncements)
        }
    }
    func getData(completion: @escaping () -> Void) {
        print("Orgakey: \(user?.orgaKey)")
        // Get a reference to the database
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
                        // Call the completion handler when data is fetched
                        completion()
                    }
                } else {
                    print("No documents found.")
                }
            }
        } else {
            print("User or orgaKey not available.")
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] as? String {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    
    func signOutFromFirebase() {
        do {
            try Auth.auth().signOut()
            print("User signed out from Firebase")
        } catch let signOutError as NSError {
            print("Error signing out from Firebase: \(signOutError.localizedDescription)")
        }
    }
}


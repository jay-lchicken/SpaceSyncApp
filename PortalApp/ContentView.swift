//
//  ContentView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 25/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MainViewViewModel()
    @AppStorage("darkMode") var darkMode: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isINC") var isINC: Bool = false
    @State private var showingUpdateAlert = false
    
    var body: some View {
        Group {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                accountView
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(.light)
        .alert(isPresented: $showingUpdateAlert) {
            Alert(title: Text("Update Available"),
                  message: Text("A newer version of the app is available. Please update to continue using."),
                  primaryButton: .default(Text("Update"), action: {
                      // Redirect the user to the App Store
                      if let url = URL(string: "https://apps.apple.com/si/app/spacesync/id6498710377") {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                      }
                  }),
                  secondaryButton: .cancel(Text("Later")))
        }
        .onAppear {
            // Check for updates when the view appears
            viewModel.checkForUpdates { updateAvailable in
                if updateAvailable {
                    showingUpdateAlert = true
                }
            }
        }
    }

    @ViewBuilder
    var accountView: some View {
        TabView {
            AnnouncementListView()
                .tabItem {
                    Label("Announcements", systemImage: "megaphone")
                        .foregroundColor(.green)
                }
            PostsListView()
                .tabItem { Label("Posts", systemImage: "camera.fill") }
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("ToDoList", systemImage: "calendar.badge.plus")
                }
            SpaceSyncAI()
                .tabItem { Label("AI", systemImage: "ellipses.bubble") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
            
            NotificationView()
                .tabItem { Label("Notifications", systemImage: "bell.circle") }
            InfoView()
                .tabItem { Label("App Info", systemImage: "info.circle") }
            
        }
    }
}
#Preview{
    ContentView()
}

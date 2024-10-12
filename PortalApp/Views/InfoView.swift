//
//  InfoView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 26/4/24.
//
import SwiftUI
import AVKit

struct InfoView: View {
    var body: some View {
        VStack {
            Text("App Info")
                .font(.system(size: 40))
                .padding()
            Divider()
            Text("If no post(s) shows up, please go to another tab and then go back. Within your workspace, share posts and announcements effortlessly using a variety of SF Symbols icons for clear and concise communication. Keep your team informed and engaged with updates tailored to your workspace's needs. The video below is a guide on the usage of this app")
                .font(.system(size: 20))
                .padding()
            
            // Assuming you have a URL for the video
            if let videoURL = Bundle.main.url(forResource: "Screen Recording 2024-05-02 at 3.50.45 PM", withExtension: "mov") {
                VideoPlayer(player: AVPlayer(url: videoURL)) {
                    // Placeholder or additional controls can be added here if needed
                }
            } else {
                Text("Video file not found")
            }

        }
    }
}

#Preview {
    InfoView()
}

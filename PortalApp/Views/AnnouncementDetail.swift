//
//  AnnouncementDetail.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import SwiftUI

struct AnnouncementDetail: View {
    var landmark: Announcement



    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading) {
                Text(landmark.title)
                    .font(.title)
                Divider()
                    
                Text("About \(landmark.title)")
                    .font(.title2)
                Text(landmark.content)
                Divider()
                if !landmark.link.isEmpty, let url = URL(string: landmark.link) {
                    Link("Provided Link", destination: url)
                }

                Text("Published By \(landmark.author)")
                Text("Date Announced: \(Date(timeIntervalSince1970: landmark.dateAdded).formatted(date: .abbreviated, time: .shortened))")
                Text("To report content, please screenshot this Id, Id: \(landmark.authorId)")
            }
            .padding()
        }
    }
}


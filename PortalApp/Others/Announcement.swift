//
//  Announcement.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import Foundation

struct Announcement: Codable, Identifiable, Equatable{
    let id: String
    let title: String
    let content : String
    let author: String
    let authorId: String
    let sf: String
    let link: String
    let dateAdded: TimeInterval
    static func ==(lhs: Announcement, rhs: Announcement) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.content == rhs.content &&
        lhs.author == rhs.author &&
        lhs.authorId == rhs.authorId &&
        lhs.sf == rhs.sf &&
        lhs.link == rhs.link &&
        lhs.dateAdded == rhs.dateAdded
    }
}

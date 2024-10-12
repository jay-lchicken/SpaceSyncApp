//
//  Posts.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import Foundation

struct Posts: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let sf: String
    let dateAdded: TimeInterval
}

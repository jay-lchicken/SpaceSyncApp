//
//  User.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//


import Foundation

struct User: Codable, Identifiable{
    let id: String
    let name: String
    let email : String
    let orgaKey: String
}


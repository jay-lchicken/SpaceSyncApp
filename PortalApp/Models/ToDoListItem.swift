 //
//  ToDoListItem.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//

import Foundation
struct ToDoListItem: Codable, Identifiable{
    let id:String
    let title:String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone:Bool
    
    mutating func setDone(_ state: Bool){
        isDone = state
    }
}

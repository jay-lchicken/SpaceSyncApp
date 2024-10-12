//
//  ToDoListItemViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
///View Model for single to do list item view
class ToDoListItemViewViewModel: ObservableObject{
    init(){}
    func toggleIsDone(item: ToDoListItem){
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("Todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())
    }
}

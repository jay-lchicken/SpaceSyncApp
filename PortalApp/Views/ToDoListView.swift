//
//  ToDoListView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//


import SwiftUI
import FirebaseFirestore

struct ToDoListView: View {
    @StateObject var viewModel : ToDoListViewViewModel
    @FirestoreQuery var items:[ToDoListItem]
    init(userId: String){
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/Todos")
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    var body: some View {
        NavigationView{
            VStack{
                List(items){ item in
                    ToDoListItemView(item: item)
                        .swipeActions{
                            Button{
                                viewModel.delete(id: item.id)
                            } label:{
                                Text("Delete")
                            }
                            .tint(.red)

                        }
                    }
                }
                .listStyle(DefaultListStyle())
            .navigationTitle("To Do List")
            .toolbar{
                Button(action: {viewModel.showingNewItemView = true}, label: {Image(systemName: "plus")})
            }
            .sheet(isPresented: $viewModel.showingNewItemView){
                NewToDoListView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

#Preview {
    ToDoListView(userId: "Ac0HK2GZmgQk5aEWvOOD4fAPV9x1")
}

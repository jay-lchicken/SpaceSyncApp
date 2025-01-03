//
//  ToDoListItemView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//
import SwiftUI

struct ToDoListItemView: View {
    @StateObject var viewModel = ToDoListItemViewViewModel()
    let item : ToDoListItem
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(item.title)
                    .bold()
                    .font(.body)
                
                Text("\(Date(timeIntervalSince1970:item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Button{
                viewModel.toggleIsDone(item: item)
            }label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill":"circle")
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    ToDoListItemView( item: .init(id: "123", title: "Get Milk", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: true))
}

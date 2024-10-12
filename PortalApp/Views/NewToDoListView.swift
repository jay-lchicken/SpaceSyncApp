//
//  NewToDoListView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 6/5/24.
//

import SwiftUI

struct NewToDoListView: View {
    @StateObject var viewModel = NewToDoListViewViewModel()
    @Binding var newItemPresented: Bool
    var body: some View {
        VStack{
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 100)
                .foregroundStyle(Color.green)
            
                // You would want a title, due date and button
            TextField("Title", text: $viewModel.title)
                .textFieldStyle(DefaultTextFieldStyle())
            DatePicker("Due date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
            Button(action: {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }) {
                    Text("Save")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                .padding()
            .alert(isPresented: $viewModel.showAlert){Alert(title:Text("Error"), message:Text( "Please fill in all fields and select due date that is today or newer"))
}        }
        .frame(maxWidth: 350)
    }
}

#Preview {
    NewToDoListView(newItemPresented: Binding(get: {return true}, set: {_ in
    }))
}

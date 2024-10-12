//
//  NewItemView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
       @Binding var newItemPresented: Bool
       
       var body: some View {
           VStack {
               Text("New Announcement")
                   .font(.system(size: 32))
                   .bold()
                   .padding(.top, 100)
                   .foregroundColor(.green)
               
               
                   // You would want a title, due date and button
                   TextField("Title", text: $viewModel.title)
               Divider()
                   TextField("Content", text: $viewModel.content)
               
               
               Divider()
               Picker("Select Symbol", selection: $viewModel.sf) {
                   ForEach(viewModel.colorOptions, id: \.self) { color in
                       Image(systemName: color)
                           .tag(color)
                   }
               }
               .pickerStyle(MenuPickerStyle())

               Divider()
               TextField("Link (Optional)", text: $viewModel.link1)
                   .autocorrectionDisabled()
                   .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
               Divider()
               
                   Button(action: {
                       if viewModel.canSave {
                           viewModel.save()
                           newItemPresented = false
                       } else {
                           viewModel.error = "Error, Please fill in all fields with a valid link if you entered a link"
                           viewModel.showAlert = true
                           
                       }
                   }) {
                       Text("Save")
                           .foregroundColor(.white)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color.green)
                           .cornerRadius(8)
                   }
                   .padding()
           }
           .frame(maxWidth: 300)
           .alert(isPresented: $viewModel.showAlert) {
               Alert(title: Text("Error"),
                     message: Text(viewModel.error),
                     dismissButton: .default(Text("OK")))
           }
       }}

#Preview {
    NewItemView(newItemPresented: Binding(get: {return true}, set: {_ in
    }))
}


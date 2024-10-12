//
//  SwiftUIView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//

import SwiftUI

struct AddPostView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var selectedImage: UIImage?
    @Binding var newItemPresented: Bool
    @State var showAlert = false
    @StateObject var viewModel = NewPostsModel()
    var body: some View {
        VStack {
            TextField("Title", text: $viewModel.title)
                .padding()
            Divider()
            TextField("Description", text: $viewModel.description)
                .padding()
            Divider()
            Picker("Select Symbol", selection: $viewModel.sf) {
                            ForEach(viewModel.colorOptions, id: \.self) { color in
                                Image(systemName: color)
                                     .tag(color)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
            
            Divider()
            Text("A Post is permanent, it cannot be deleted")
            Button(action: {
                // Call uploadPost with the completion closure
                if viewModel.canSave{
                    viewModel.save()
                    newItemPresented = false
                }
                else{
                    print("Failed")
                }
                }
                   
            ) {
                Text("Upload Post")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Add Post")
        .alert(isPresented: $showAlert){
            Alert(title: Text("Fill in all fields"), message: Text("!!!"))
        }
            
    }
}




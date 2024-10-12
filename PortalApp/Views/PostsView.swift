//
//  PostsView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
import SwiftUI

struct PostsListView: View {
    let names = ["Green", "Red", "Blue", "Yellow"]
    var randomName: String { names.randomElement()! }
    @ObservedObject var model = PostViewModel()
    let refreshInterval: TimeInterval = 2
    
    var body: some View {
        NavigationView {
            if false{
                
            } else {
                List(model.list.sorted(by: { $0.dateAdded > $1.dateAdded })) { post in
                    PostRow(color: randomName, post: post)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Posts")
                .toolbar {
                    Button(action: {
                        model.showingNewItemView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $model.showingNewItemView) {
                    AddPostView(newItemPresented: $model.showingNewItemView)
                }
            }
        }
        .onAppear {
            model.fetchUser()
            model.getData()
            print(model.list)
        }
    }
}

struct PostRow: View {
    let color: String
    var post: Posts

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                Spacer()
                if !post.sf.isEmpty {
                    switch color {
                        case "Yellow":
                            Image(systemName: post.sf)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.yellow)
                        case "Red":
                            Image(systemName: post.sf)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        case "Green":
                            Image(systemName: post.sf)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.green)
                        case "Blue":
                            Image(systemName: post.sf)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.blue)
                        default:
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                    }
                } else {
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(post.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}


struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}





//
//  AnnouncementListView.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import SwiftUI
import FirebaseAuth

struct AnnouncementListView: View {
    @ObservedObject var model = viewModel()
    let userId = Auth.auth().currentUser?.uid
    let refreshInterval: TimeInterval = 0.1
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.list.sorted(by: { $0.dateAdded > $1.dateAdded })) { landmark in
                    NavigationLink(destination: AnnouncementDetail(landmark: landmark)) {
                        AnnouncementRow(landmark: landmark)
                    }
                    .swipeActions {
                        Button {
                            model.delete(id: landmark.id, item: landmark)
                        } label: {
                            Label("Report", systemImage: "flag.fill")
                        }
                        .tint(.red)
                        
                        if let userId = Auth.auth().currentUser?.uid,
                           ["syv6uQAOqlNPFgAw5qDseMqKP2l1", "usnvhOcj0Kg3kEWL4rnfVuHncV92", "pxspDWLateh7iwNBpKOiw21YfL23"].contains(userId) {
                            Button {
                                model.delete2(id: landmark.id)
                            } label: {
                                Text("Delete")
                            }
                            .tint(.green)
                        }
                    }
                }
            }
            .refreshable {
                model.fetchUser()
                model.getData()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Announcements")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        model.showingNewItemView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $model.showingNewItemView) {
                NewItemView(newItemPresented: $model.showingNewItemView)
            }
        }
        .onAppear {
            model.fetchUser()
            model.getData()
            print(model.list)
            Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { _ in
                model.getData()
            }
        }
    }
}

#Preview {
    AnnouncementListView()
}

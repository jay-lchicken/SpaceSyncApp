import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @State private var showDeleteConfirmation = false
    @AppStorage("faceid") private var faceid = false

    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    AvatarView()
                    UserDetailsView(user: user)
                    
                    DeleteAccountButton(showDeleteConfirmation: $showDeleteConfirmation) {
                        viewModel.deleteAccount()
                    }
                    Spacer()
                } else {
                    Text("Loading Profile...")
                }
                Button(action: {

                                    let firebaseAuth = Auth.auth()
                                    do {
                                        try firebaseAuth.signOut()
                                    } catch let signOutError as NSError {
                                        print("Error signing out: %@", signOutError)
                                    }
                                }) {
                                    Text("Logout")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                
                                }
                PasswordResetMessage()
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteAccount()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct AvatarView: View {
    var body: some View {
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.indigo)
            .frame(width: 125, height: 125)
            .padding()
    }
}

struct UserDetailsView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            UserInfoRow(title: "Name:", value: user.name)
            UserInfoRow(title: "Email:", value: user.email)
            UserInfoRow(title: "OrgaKey:", value: user.orgaKey)
        }
        .padding()
    }
}

struct UserInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .bold()
            Text(value)
        }
    }
}

struct TogglesView: View {
    @Binding var faceid: Bool
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $isDarkMode)
        }
        .padding()
    }
}

struct DeleteAccountButton: View {
    @Binding var showDeleteConfirmation: Bool
    var onDelete: () -> Void
    
    var body: some View {
        Button("Delete Account") {
            showDeleteConfirmation = true
        }
        .foregroundColor(.red)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete"), action: onDelete),
                secondaryButton: .cancel()
            )
        }
        .padding()
    }
}

struct LogoutButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Logout")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(8)
        }
        .padding()
    }
}

struct PasswordResetMessage: View {
    var body: some View {
        Text("Password Reset is available when you logout")
    }
}

#Preview {
    ProfileView()
}

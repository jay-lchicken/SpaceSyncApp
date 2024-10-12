//
//  ProfileViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 18/4/24.
//


import FirebaseAuth
import FirebaseFirestore
import Foundation
import CoreImage.CIFilterBuiltins
class ProfileViewViewModel: ObservableObject{
    init(){}
    @Published var showingEditModel = false
    @Published var user: User? = nil
    @Published var showAlert = false
    private func validate() -> Bool{
        return false
    }
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            // User is not signed in
            return
        }
        
        user.delete { error in
            if let error = error {
                // An error occurred while deleting the account
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                // Account deletion successful
                print("Account deleted successfully")
                // You might want to sign out the user after deletion
                try? Auth.auth().signOut()
            }
        }
    }
        
        
    func generateQRCode(from userID: String) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(userID.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        // Adjust the scale to increase the resolution
        let scale = UIScreen.main.scale
        let transformedImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        
        // Adjust the size of the output image
        let outputSize = CGSize(width: 200 * scale, height: 200 * scale)
        let context = CIContext()
        if let cgImage = context.createCGImage(transformedImage!, from: transformedImage!.extent) {
            // Increase rendering quality
            let uiImage = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
            return uiImage
        }
        return nil
    }
    func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument{snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            DispatchQueue.main.async {
                self.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    orgaKey: data["orgaKey"] as? String ?? "")
            }
        }
    }
}

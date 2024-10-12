//
//  MainViewViewModel.swift
//  PortalApp
//
//  Created by Lai Hong Yu on 15/4/24.
//

import FirebaseAuth
import Foundation

class MainViewViewModel:ObservableObject{
    @Published var currentUserId:String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    init(){
        self.handler = Auth.auth().addStateDidChangeListener { [weak self]_, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
            self?.currentUserId = user?.uid ?? ""}
    }
    public var isSignedIn:Bool{
        return Auth.auth().currentUser != nil
    }
    func checkForUpdates(completion: @escaping (Bool) -> Void) {
            // Get the current app version
            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                completion(false)
                return
            }
            
            // Replace "YOUR_APP_ID_HERE" with your actual App Store ID
            let appStoreId = "6498710377"
            
            // Fetch the latest version from the App Store
            let url = URL(string: "https://apps.apple.com/si/app/spacesync/id\(appStoreId)")!
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AppStoreLookupResult.self, from: data)
                    guard let latestVersion = result.results.first?.version else {
                        completion(false)
                        return
                    }
                    
                    // Compare versions
                    let updateAvailable = latestVersion.compare(currentVersion, options: .numeric) == .orderedDescending
                    completion(updateAvailable)
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    struct AppStoreLookupResult: Codable {
        let results: [AppStoreApp]
    }

    struct AppStoreApp: Codable {
        let version: String
    }
}

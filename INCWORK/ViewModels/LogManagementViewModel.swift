//
//  LogManagementViewModel.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//
import CoreLocation
import Foundation
import SwiftUICore
import DataSave
import UIKit
class LogManagementViewModel: ObservableObject {
    @Published var fontSize: ContentSizeCategory = .large
    @Published var showAlert: Bool = false
    @Published var logs: [log] = []
    @Published var showNewItemView: Bool = false
    //Variables for new log view
    @Published var nameOfAccomplice: String = ""
    @Published var whyWasTheCoinStolen: String = ""
    @Published var howWasTheCoinStolen: String = ""
    @Published var locationFled: CLLocationCoordinate2D? = nil
    @Published var locationNow: CLLocationCoordinate2D? = nil
    @Published var generator = UINotificationFeedbackGenerator()
    private let key = "announcementList"
    init() {
//        if let data = UserDefaults.standard.data(forKey: key) {
//            let decoder = JSONDecoder()
//            if let decodedList = try? decoder.decode([log].self, from: data) {
//                self.logs = decodedList
//            }
//        }
        if let logss: [log] = DataSave.retrieveFromUserDefaults(forKey: key, as: [log].self) {
            logs = logss
        } else {
            print("No data found for the given key.")
        }
        
    }
    func sync(){
        let success = DataSave.saveToUserDefaults(logs, forKey: key)
    }
    func addData(logging: log){
        logs.append(logging)
        let success = DataSave.saveToUserDefaults(logs, forKey: key)
        print("added data: \(success)")
        
    }
    func deleteData(index: Int){
        logs.remove(at: index)
        let success = DataSave.saveToUserDefaults(logs, forKey: key)
        print("deleted data \(success)")
    }
    func verify() -> Bool{
        guard !nameOfAccomplice.isEmpty else {
            showAlert = true
            return false
        }
        guard !whyWasTheCoinStolen.isEmpty else {
            showAlert = true
            return false
        }
        guard !howWasTheCoinStolen.isEmpty else {
            showAlert = true
            return false
        }
        guard locationFled != nil else {
            showAlert = true
            return false
        }
        guard locationNow != nil else {
            showAlert = true
            return false
        }
        return true
    }
    func add(){
        
        
        let currentData = log(nameOfAccomplice: nameOfAccomplice, locationFled: log.LocationData(from: CLLocation(latitude: locationFled!.latitude, longitude: locationFled!.longitude)), dateAdded: Date().timeIntervalSince1970, whyStolen: whyWasTheCoinStolen, whereAreTheyNow: log.LocationData(from: CLLocation(latitude: locationNow!.latitude, longitude: locationNow!.longitude)), howTheyStoleTheCoin: howWasTheCoinStolen)
       nameOfAccomplice = ""
       whyWasTheCoinStolen = ""
       howWasTheCoinStolen = ""
       locationNow = nil
       locationFled = nil
        
        addData(logging: currentData)
    }

}

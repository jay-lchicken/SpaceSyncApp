//
//  LogDetailsView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//



import SwiftUI
import CoreLocation
import MapKit

struct LogDetailsView: View {
    @Binding var log: log
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {

                Text("Accomplice Details")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading) {
                    Label("Name of Accomplice:", systemImage: "person.fill")
                        .font(.headline)
                    Text(log.nameOfAccomplice)
                        .font(.body)
                }
                
                Divider()

                VStack(alignment: .leading) {
                    Label("How the Coin was Stolen:", systemImage: "exclamationmark.triangle.fill")
                        .font(.headline)
                    Text(log.howTheyStoleTheCoin)
                        .font(.body)
                }
                
                Divider()
                VStack(alignment: .leading) {
                    Label("Where did they flee: ", systemImage: "location.fill")
                        .font(.headline)
                    Text("\(log.locationFled.latitude), \(log.locationFled.longitude)")
                        .font(.body)
                    
                    MapView(coordinate: log.locationFled.toCLLocation().coordinate)
                        .frame(height: 200)
                        .cornerRadius(8)
                }
                Divider()

                VStack(alignment: .leading) {
                    Label("Where are they now:", systemImage: "location.fill")
                        .font(.headline)
                    Text("\(log.whereAreTheyNow.latitude), \(log.whereAreTheyNow.longitude)")
                        .font(.body)
                    
                    MapView(coordinate: log.whereAreTheyNow.toCLLocation().coordinate)
                        .frame(height: 200)
                        .cornerRadius(8)
                }
                
                Divider()


                VStack(alignment: .leading) {
                    Label("Why was the Coin Stolen:", systemImage: "questionmark.circle.fill")
                        .font(.headline)
                    Text(log.whyStolen)
                        .font(.body)
                    
                    Label("Date Added:", systemImage: "calendar")
                        .font(.headline)
                    Text("\(Date(timeIntervalSince1970: log.dateAdded).formatted(date: .abbreviated, time: .shortened))")
                        .font(.body)
                }

                Spacer()
            }
        }
        .padding()
    }
    

}


struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001) //Show a 1km Radius
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        uiView.addAnnotation(annotation)
    }
}

//
//  HomeView.swift
//  INCINCINC
//
//  Created by Lai Hong Yu on 9/12/24.
//

import SwiftUI
import MapKit
struct ConnectedView: View {
    @ObservedObject var viewModel: LogManagementViewModel
    var body: some View {
        NavigationStack{
            VStack{
                Text("Locations Fled")
                    .bold()
                MapViews(logs: viewModel.logs)
                Text("Locations Now")
                    .bold()
                MapViewss(logs: viewModel.logs)
            }
            .navigationTitle("Overview")
        }
    }
}
struct MapViews: UIViewRepresentable {
    var logs: [log]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)

        for log in logs {
            let annotation = MKPointAnnotation()
            annotation.title = log.nameOfAccomplice
            annotation.subtitle = Date(timeIntervalSince1970: log.dateAdded).formatted(date: .abbreviated, time: .shortened)
            annotation.coordinate = CLLocationCoordinate2D(latitude: log.locationFled.latitude, longitude: log.locationFled.longitude)
            mapView.addAnnotation(annotation)
        }

        if !logs.isEmpty {
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViews

        init(_ parent: MapViews) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "LogAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.pinTintColor = .red
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
}
struct MapViewss: UIViewRepresentable {
    var logs: [log]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        for log in logs {
            let annotation = MKPointAnnotation()
            annotation.title = log.nameOfAccomplice
            annotation.subtitle = Date(timeIntervalSince1970: log.dateAdded).formatted(date: .abbreviated, time: .shortened)
            annotation.coordinate = CLLocationCoordinate2D(latitude: log.whereAreTheyNow.latitude, longitude: log.whereAreTheyNow.longitude)
            mapView.addAnnotation(annotation)
        }

//        if let firstLog = logs.first {
//            let region = MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: firstLog.locationFled.latitude, longitude: firstLog.locationFled.longitude),
//                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//            )
//            mapView.setRegion(region, animated: true)
//        }
        if !logs.isEmpty {
            mapView.showAnnotations(mapView.annotations, animated: true)
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewss

        init(_ parent: MapViewss) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "LogAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.pinTintColor = .red
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
}


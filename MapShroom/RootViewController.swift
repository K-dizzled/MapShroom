//
//  ViewController.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import UIKit
import MapKit

class RootViewController: UIViewController {
    
    private enum Constants {
        static let mapAnnotationIdentifier = "shroom"
    }
    
    private var mapNeedsToBeCentered : Bool = false
    private let shrooms : [ShroomAnnotation] = [
        ShroomAnnotation(title: "Подосиновик",
                         subtitle: "Нашел",
                         image: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Mushroom.svg")!, userId: "123456789",
                         coordinate: CLLocationCoordinate2D(latitude: 60.052670, longitude: 30.324212),
                         type: "podos1"
                        ),
        ShroomAnnotation(title: "Подберезовик",
                         subtitle: "Топ место",
                         image: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Mushroom.svg")!, userId: "123456789",
                         coordinate: CLLocationCoordinate2D(latitude: 60.053373, longitude: 30.329288),
                         type: "podb1"
                        )
    ]
    
    private lazy var mapView : MKMapView = {
        var map = MKMapView()

        map.showsUserLocation = true
        map.showsCompass = false
        
        mapNeedsToBeCentered = true
        
        return map
    }()
    
    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubviews(mapView)
        locationManager.delegate = self
        
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        if authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutMap()
    }
    
    private func layoutMap() {
        mapView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: view.frame.width,
                height: view.frame.height
            )
        )
    }
}

extension RootViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .notDetermined:
            debugPrint("NotDetermined")
        case .restricted:
            debugPrint("Restricted")
        case .denied:
            debugPrint("Denied")
        case .authorizedAlways:
            debugPrint("AuthorizedAlways")
        case .authorizedWhenInUse:
            debugPrint("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {

        print("Location changed \(locations.first!.coordinate)")
        
        if mapNeedsToBeCentered {
            guard let location = locations.first else {
                return
            }
                
            mapView.centerToLocation(location)
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
    
            mapView.setRegion(coordinateRegion, animated: true)
            mapNeedsToBeCentered = false
            
            for shroom in shrooms {
                self.mapView.addAnnotation(shroom)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
}

extension RootViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ShroomAnnotation else {
            return nil
        }
        
        let identifier = Constants.mapAnnotationIdentifier
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier)
            
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

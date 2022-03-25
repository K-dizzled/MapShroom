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
    private let shrooms : [Shroom] = [
        Shroom(title: "Подосиновик",
               locationName: "Нашел",
               userId: "123456789",
               coordinate: CLLocationCoordinate2D(latitude: 60.052670, longitude: 30.324212)
              ),
        Shroom(title: "Подберезовик",
               locationName: "Топ место",
               userId: "123456789",
               coordinate: CLLocationCoordinate2D(latitude: 60.053373, longitude: 30.329288)
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
        guard let annotation = annotation as? Shroom else {
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

private extension MKMapView {
  func centerToLocation(_ location: CLLocation,
                        regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
      
    setRegion(coordinateRegion, animated: true)
  }
}

protocol MapPoint {
    var radius: Int { get set }
    var title: String? { get set }
    var image: URL? { get set }
    var locationName: String? { get set }
    var intensity: Int { get set }
    var addedBy: String { get }
    var timestampAdded: Double { get }
}

class Shroom : NSObject, MapPoint, MKAnnotation {
    var title: String?
    var locationName: String?
    var radius: Int
    var image: URL?
    var intensity: Int
    var addedBy: String
    var timestampAdded: Double
    
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         locationName: String?,
         radius: Int = 10,
         image: URL? = nil,
         intensity: Int = 10,
         userId: String,
         coordinate: CLLocationCoordinate2D
    ) {
        
        self.title = title
        self.locationName = locationName
        self.radius = radius
        self.image = image
        self.intensity = intensity
        
        self.addedBy = userId
        self.timestampAdded = NSDate().timeIntervalSince1970
        
        self.coordinate = coordinate

        super.init()
    }
}

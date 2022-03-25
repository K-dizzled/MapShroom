//
//  MapViewController.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private enum Constants {
        static let mapAnnotationIdentifier = "shroom"
    }
    
    private var mapNeedsToBeCentered : Bool = false
    private var locationManager = CLLocationManager()

    private lazy var mapView : MKMapView = {
        var map = MKMapView()

        map.showsUserLocation = true
        map.showsCompass = false
        
        mapNeedsToBeCentered = true
        
        return map
    }()
    
    private var allAnnotations: [MapPoint]?
    
    private var displayedAnnotations: [MKAnnotation]? {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                mapView.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                mapView.addAnnotations(newAnnotations)
            }
            if let location = mapView.userLocation.location {
                mapView.centerToLocation(location)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubviews(mapView)
        locationManager.delegate = self
        //mapView.delegate = self
        mapView.register(ShroomMarkerAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
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
        
        registerMapAnnotationViews()
        
        let shroomAnnotation1 = ShroomAnnotation(
            title: "Подосиновик",
            subtitle: "Нашел",
            image: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Mushroom.svg")!,
            userId: "123456789",
            coordinate: CLLocationCoordinate2D(
                latitude: 60.052670,
                longitude: 30.324212
            ),
            type: "podos1"
        )
        
        let shroomAnnotation2 = ShroomAnnotation(
            title: "Подберезовик",
            subtitle: "Топ место",
            image: URL(string: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Mushroom.svg")!,
            userId: "123456789",
            coordinate: CLLocationCoordinate2D(
                latitude: 60.053373,
                longitude: 30.329288
            ),
            type: "podb1"
        )
        
        // Create the array of annotations and the specific annotations for the points of interest.
        allAnnotations = [shroomAnnotation1, shroomAnnotation2]
        
        // Dispaly all annotations on the map.
        showAllAnnotations()
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
    
    /// Register the annotation views with the `mapView` so the system can create and efficently reuse the annotation views.
    /// - Tag: RegisterAnnotationViews
    private func registerMapAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(ShroomAnnotation.self))
    }
    
    private func displayOneClass(_ annotationType: AnyClass) {
        let annotation = allAnnotations?.first { (annotation) -> Bool in
            return annotation.isKind(of: annotationType)
        }
        
        if let oneAnnotation = annotation {
            displayedAnnotations = [oneAnnotation]
        } else {
            displayedAnnotations = []
        }
    }
    
    private func displaySpecificTypeOfClass(_ annotationType: AnyClass, type: String) {
        let annotations = allAnnotations?.filter { (annotation) -> Bool in
            return annotation.isKind(of: annotationType) && annotation.type == type
        }
        
        displayedAnnotations = annotations
    }
    
    private func showOnlyShroomAnnotation() {
        displayOneClass(ShroomAnnotation.self)
    }
    
    private func showAllAnnotations() {
        displayedAnnotations = allAnnotations
    }
}

extension MapViewController : CLLocationManagerDelegate {
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
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
}
//
//extension MapViewController: MKMapViewDelegate {
//
//    /// Called whent he user taps the disclosure button in the Shroom callout.
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//
//        // This illustrates how to detect which annotation type was tapped on for its callout.
//        if let annotation = view.annotation, annotation.isKind(of: ShroomAnnotation.self) {
//            debugPrint("User tapped on annotation")
//        }
//    }
//
//    /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation.
//    /// - Tag: CreateAnnotationViews
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard !annotation.isKind(of: MKUserLocation.self) else {
//            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
//            return nil
//        }
//
//        var annotationView: MKAnnotationView?
//        if let annotation = annotation as? ShroomAnnotation {
//            annotationView = setupShroomAnnotationView(for: annotation, on: mapView)
//        }
//
//        return annotationView
//    }
//
//    /// The map view asks `mapView(_:viewFor:)` for an appropiate annotation view for a specific annotation. The annotation
//    /// should be configured as needed before returning it to the system for display.
//    /// - Tag: ConfigureAnnotationViews
//    private func setupShroomAnnotationView(for annotation: ShroomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
//        let flagAnnotationView = MKAnnotationView()
//
//        flagAnnotationView.canShowCallout = true
//
//        // Provide the annotation view's image.
//        let image = #imageLiteral(resourceName: "Image")
//        flagAnnotationView.image = image
//        // Provide the left image icon for the annotation.
//        flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "sf_icon"))
//
//
//        // Offset the shroom annotation so that the flag pole rests on the map coordinate.
//        let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
//        flagAnnotationView.centerOffset = offset
//
//        return flagAnnotationView
//    }
//}

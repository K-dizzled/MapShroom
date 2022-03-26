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
        static let openBSize: CGFloat = 70
        static let plusButtonPointSize : CGFloat = 25
        static let coordinateConstScale : CGFloat = 3000
        static let navBarHeight : CGFloat = 44
        static let levelOfAddButton : CGFloat = 0.85
    }
    
    private lazy var visualEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        
        view.layer.cornerRadius = Constants.openBSize / 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var button: UIButton = {
        let but = UIButton()
        
        let config = UIImage.SymbolConfiguration(
            pointSize: Constants.plusButtonPointSize,
            weight: .light
        )
        
        but.setImage(
            UIImage(
                systemName: "plus",
                withConfiguration: config
            )?.withTintColor(
                .label,
                renderingMode: .alwaysOriginal
            ),
            for: .normal
        )
        
        but.addTarget(self, action: #selector(addFinding), for: .touchUpInside)

        return but
    }()
    
    private lazy var mapView : MKMapView = {
        var map = MKMapView()

        map.showsUserLocation = true
        mapNeedsToBeCentered = true
        
        return map
    }()
    
    private var mapNeedsToBeCentered : Bool = false
    private var locationManager = CLLocationManager()
    private lazy var trackButton = MKUserTrackingButton(mapView: mapView)
    
    private var allAnnotations: [Finding] = [
        Finding(
            type: .mushroom,
            latitude: 60.053373,
            longitude: 30.329288
        ),
        Finding(
            type: .nature,
            latitude: 60.052670,
            longitude: 30.324212
        )
    ]
    
    private var displayedAnnotations: [Finding]? {
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
    
    private lazy var navBar : UINavigationBar = {
        let navBar = UINavigationBar()
        
        // Make navigation bar transparent
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = .clear
        
        // Set empty title
        let navItem = UINavigationItem(title: "")
        
        // Add compass to the right of the navigation item
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = false
        
        // Unhides when location authorization is given.
        trackButton.isHidden = false
        navItem.leftBarButtonItem = UIBarButtonItem(customView: trackButton)
    
        // Add navigation item to navigation bar
        navBar.setItems([navItem], animated: false)
        
        return navBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            mapView,
            visualEffectView,
            button,
            navBar
        )
        
        locationManager.delegate = self
        mapView.delegate = self

        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        registerAnnotationViewClasses()
        
        // Dispaly all annotations on the map.
        showAllAnnotations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutMap()
        layoutAddPointButtonAndVE()
        //setupCompassButton()
        layoutNavBar()
    }
    
    private func registerAnnotationViewClasses() {
        mapView.register(ShroomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(NatureAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func layoutNavBar() {
        navBar.frame = CGRect(
            x: 0, y: view.safeAreaInsets.top,
            width: view.frame.size.width,
            height: Constants.navBarHeight
        )
    }
    
    private func layoutAddPointButtonAndVE() {
        visualEffectView.frame = CGRect(
            x: (view.frame.width - Constants.openBSize) / 2,
            y: view.frame.height * Constants.levelOfAddButton,
            width: Constants.openBSize,
            height: Constants.openBSize
        )
        
        button.frame = visualEffectView.frame
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
    
    private func showAllAnnotations() {
        displayedAnnotations = allAnnotations
    }
    
    @objc private func addFinding() {
        debugPrint("New item selcted")
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
            case .notDetermined:
                debugPrint("NotDetermined")
            case .restricted:
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                locationManager.requestWhenInUseAuthorization()
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
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: Constants.coordinateConstScale,
                longitudinalMeters: Constants.coordinateConstScale
            )
    
            mapView.setRegion(coordinateRegion, animated: true)
            mapNeedsToBeCentered = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }
}

extension MapViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FilterPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Finding else { return nil }

        switch annotation.type {
        case .nature:
            return NatureAnnotationView(annotation: annotation, reuseIdentifier: NatureAnnotationView.ReuseID)
        case .mushroom:
            return ShroomAnnotationView(annotation: annotation, reuseIdentifier: ShroomAnnotationView.ReuseID)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if(view.isKind(of: NatureAnnotationView.self) || view.isKind(of: ShroomAnnotationView.self)) {
            let filterVC = FilterViewController()
            
            filterVC.modalPresentationStyle = .custom
            filterVC.transitioningDelegate = self
            
            filterVC.onDoneBlock = { result in
                let pin = view.annotation
                mapView.deselectAnnotation(pin, animated: true)
            }
            
            self.present(filterVC, animated: true, completion: nil)
        }
    }
}

//
//  MKMapView+Extension.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        setRegion(coordinateRegion, animated: true)
    }
}


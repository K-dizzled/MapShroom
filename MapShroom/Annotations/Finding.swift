//
//  Finding.swift
//  MapShroom
//
//  Created by Андрей on 26.03.2022.
//

import MapKit

class Finding: NSObject, MKAnnotation {
    
    enum FindingType: Int, Decodable {
        case mushroom
        case nature
    }
    
    var type: FindingType = .nature
    var info: MapPointInfo? = nil
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    init(type: FindingType,
         latitude: CLLocationDegrees,
         longitude: CLLocationDegrees
    ) {
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
    }
}

//
//  ShroomAnnotation.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import MapKit
import UIKit

class ShroomAnnotation : NSObject, MapPoint {
    var title: String?
    
    var subtitle: String?
    
    var radius: Int
    
    var image: URL
    
    var intensity: Int
    
    var addedBy: String
    
    var timestampAdded: Double
    
    var type: String
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         subtitle: String?,
         radius: Int = 10,
         image: URL,
         intensity: Int = 10,
         userId: String,
         coordinate: CLLocationCoordinate2D,
         timestamp: Double? = nil,
         type: String
    ) {
        self.title = title
        
        self.subtitle = subtitle
        
        self.radius = radius
        
        self.image = image
        
        self.intensity = intensity
        
        self.addedBy = userId
        
        self.type = type
        
        if let timestamp = timestamp {
            self.timestampAdded = timestamp
        } else {
            self.timestampAdded = NSDate().timeIntervalSince1970
        }
        
        self.coordinate = coordinate

        super.init()
    }
}

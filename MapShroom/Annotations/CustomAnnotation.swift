//
//  CustomAnnotation.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation
import MapKit

protocol MapPoint : MKAnnotation {
    // This property indicates the radius in whivh the specie
    // was found
    var radius: Int { get set }
    
    var title: String? { get set }

    var image: URL { get set }
    
    var subtitle: String? { get set }
    
    // This property indicates the intensity of the distriubution of
    // particular specie
    var intensity: Int { get set }
    
    // UiD of the user who have added the point
    var addedBy: String { get }
    
    // Date of adding in timestamp 
    var timestampAdded: Double { get }
    
    var type: String { get }
    
    dynamic var coordinate: CLLocationCoordinate2D { get set }
}

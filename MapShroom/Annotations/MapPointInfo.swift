//
//  MapPointInfo.swift
//  MapShroom
//
//  Created by Андрей on 26.03.2022.
//

import Foundation

struct MapPointInfo {
    // This property indicates the radius in whivh the specie
    // was found
    var radius: Int = 10
    
    var title: String = ""

    var image: URL?
    
    var subtitle: String?
    
    // This property indicates the intensity of the distriubution of
    // particular specie
    var intensity: Int = 1
    
    // UiD of the user who have added the point
    var addedBy: String
    
    // Date of adding in timestamp
    var timestampAdded: Double
    
    var type: String
}
